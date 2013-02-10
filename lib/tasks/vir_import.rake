# encoding: utf-8

BASE_DN = 'ou=people,ou=sch,o=bme,c=hu'
NEPTUN_URN = 'urn:mace:terena.org:schac:personalUniqueCode:hu:BME-NEPTUN:'
VIRID_URN = 'urn:mace:terena.org:schac:personalUniqueID:hu:BME-SCH-VIR:person:'

# virdb::grp_id, array index = APP DB group id
SZK_VIR_ID = 16
GROUPS_VIR_IDS = [0, 0, 0, 0, 0, 0, 0, #dummy
    106, #kirdev
    57, #ac
    38, #bss
    44, #kafu
    47, #kszk
    353, #lego
    402, #sds
    342 #sem
]

# map groups: virdb<->APP db
# iterate through the rows of the csv
# -- member in the virdb? search (neptun || mail)
# -- member in the ldap? search for (login || neptun || mail) <- we need login info for the registration!
# -- -- member not in the APP db:
#           * save new member with the given data (CSV+virdb)
# -- -- save SZK group membership with the proper 'from' date
# -- -- iterate through user group memberships in virdb
# -- -- -- save the given app group membership with proper 'from' date

desc "Import members from the crossreferenced VIRDb and csv"
task :vir_import => :environment do
    # require here so it wont interfere with or slow down other tasks
    require 'rubygems'
    require 'sequel'
    require 'ldap'
    require 'csv'
    require './lib/tasks/vir_member'
    time_begin = Time.now
    puts "begin"

    db_conn = Sequel.connect('postgres://kir:alma123@localhost/vir')

    ds_conn = ds_connect
    migrate_members(ds_conn, db_conn)
    ds_conn.unbind

    puts "end... elapsed time=" + (Time.now - time_begin).to_s
end

def ds_connect
    conn = LDAP::Conn.new('localhost', 5389)
    conn.bind('cn=Directory Manager', 'alma123')
    conn.perror('bind')
    conn
end

def migrate_members(ds_conn, db_conn)
    CSV.foreach('/tmp/members.csv', :headers => true) do |row|
        member = VirMember.new
        member.full_name = row['name']
        member.email = row['mail']
        member.enrollment_year = row['begin_yr']
        member.login = row['login']
        member.neptun = row['neptun']
        group = row['group']

        get_from_ds(ds_conn, member)

        if member.login.nil?
            p 'login name not found for=' + member.name
        else
            # got login, save member
            begin
                p '--' + member.name
                member.univ_year = 0
                if member.enrollment_year.blank?
                    member.enrollment_year = 0
                end
                member.save(:validate => false)

                ms_created = false;
                unless member.vir_id.nil?
                    db_conn.fetch('SELECT grp_id, membership_start
                    FROM grp_membership
                    WHERE usr_id = ' + member.vir_id + '
                    AND grp_id IN (' + GROUPS_VIR_IDS.join(',') + ')
                    AND membership_end IS NULL') do |vir_membership|

                        group_virid = vir_membership[:grp_id]
                        from_date = vir_membership[:membership_start]

                        new_membership(GROUPS_VIR_IDS.index(group_virid), from_date, member)
                        ms_created = true
                    end
                end

                unless ms_created
                    from_date = nil
                    unless member.vir_id.nil?
                        db_conn.fetch('SELECT grp_id, membership_start
                        FROM grp_membership
                        WHERE usr_id = ' + member.vir_id + '
                        AND grp_id = ' + SZK_VIR_ID.to_s +
                        ' AND membership_end IS NULL') do |vir_membership|

                            from_date = vir_membership[:membership_start]
                        end
                    end

                    from_date ||= Date.today
                    new_membership(group, from_date, member) # put groups from csv 'group' field
                end
            rescue Exception => e  # i know it's bad Pokemon exception handling...
                p 'sg went wrong on member=' + member.full_name + '; msg=' + e.message
                p member.inspect
                p e.backtrace
            end
        end

    end
end

def get_from_ds(ds_conn, member)
    attrs = ['schacPersonalUniqueID', 'uid', 'mail', 'schacPersonalUniqueCode', 'displayName']

    filter = '(mail=' + member.email + ')'
    unless member.neptun.nil?
        filter = '(|' + filter + '(schacPersonalUniqueCode=' + NEPTUN_URN + member.neptun + '))'
    end

    ds_conn.search(BASE_DN, LDAP::LDAP_SCOPE_SUBTREE, filter, attrs) { |entry|

        entry_uid = entry.vals('uid')
        unless entry_uid.nil?
            member.login = entry_uid.first
        end

        entry_vir_id = entry.vals('schacPersonalUniqueID')
        unless entry_vir_id.nil?
            member.vir_id = entry_vir_id.first
            member.vir_id = member.vir_id.slice(VIRID_URN.size, entry_vir_id.first.size)
        end

        entry_nick = entry.vals('displayName')
        unless entry_nick.nil?
            member.nick = entry_nick.first.force_encoding('utf-8')
        end
    }
end

def new_membership(group_id, from_date, member)
    ms = Group.find(group_id).memberships.build from_date: from_date
    ms.accepted = true
    ms.member = member
    ms.save

    p '-- -- membership: ' + group_id.to_s + '; ('+ms.from_date.to_s+')'
end