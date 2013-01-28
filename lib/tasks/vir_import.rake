require 'rubygems'
require 'sequel'
require 'ldap'
require 'csv'

BASE_DN = 'ou=people,ou=sch,o=bme,c=hu'
NEPTUN_URN = 'urn:mace:terena.org:schac:personalUniqueCode:hu:BME-NEPTUN:'
VIRID_URN = 'urn:mace:terena.org:schac:personalUniqueID:hu:BME-SCH-VIR:person:'

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

        if member.login.nil?
            # try searching for member login in the ds
            get_from_ds(ds_conn, member)
        end

        if member.login.nil?
            p 'login name not found for=' + member.full_name
        else
            # got login, save member

            # iterate through groups

            # save memberships
        end

        # DB.fetch("
        #   SELECT usr_email, usr_neptun, membership_start FROM users
        #   INNER JOIN grp_membership ON (users.usr_id = grp_membership.usr_id)
        #   WHERE grp_membership.grp_id=16 AND grp_membership.membership_end IS NULL") do |row|
        #   puts row[:usr_id]
        # end
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
            member.nick = entry_nick.first
        end
    }
end