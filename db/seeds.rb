# encoding: UTF-8
# groups seed data

szk = Group.create(name: 'Simonyi Károly Szakkollégium',
                   founded: '2003',
                   url: 'http://simonyi.bme.hu',
                   mail_list: 'szk@sch.bme.hu',
                   shortname: 'Szk')
szk.save

kirdev = Group.create name: "KIR fejlesztők és üzemeltetők",
                      founded: 2001,
                      url: "http://kir-dev.sch.bme.hu",
                      mail_list: "kir-dev@sch.bme.hu",
                      shortname: "Kir-Dev"
kirdev.save

Group.create(name: 'AC Studio & Live',
             founded: '1993',
             url: 'http://acstudio.sch.bme.hu/',
             mail_list: 'ac@sch.bme.hu',
             shortname: 'AC').save


Group.create(name: 'Budavári Schönherz Stúdió',
             founded: '1962',
             url: 'http://bss.sch.bme.hu',
             mail_list: 'bss@sch.bme.hu',
             shortname: 'BSS').save


Group.create(name: 'HA5KFU',
             founded: '1954',
             url: 'http://ha5kfu.sch.bme.hu/',
             mail_list: 'ha5kfu@sch.bme.hu',
             shortname: 'Kafu').save


Group.create(name: 'Kollégiumi Számítástechnikai Kör',
             founded: '1977',
             url: 'http://kszk.sch.bme.hu/',
             mail_list: 'kszk@sch.bme.hu',
             shortname: 'KSZK').save


Group.create(name: 'Lego kör',
             founded: '2008',
             url: 'http://lego.sch.bme.hu/Lego',
             mail_list: 'lego@sch.bme.hu',
             shortname: 'Lego').save


Group.create(name: 'Schönherz Design Stúdió',
             founded: '2010',
             url: 'http://design.sch.bme.hu/',
             mail_list: 'levlista@schdesign.hu',
             shortname: 'SDS').save


Group.create(name: 'Schönherz Elektronikai Műhely',
             founded: '2008',
             url: 'http://sem.sch.bme.hu/',
             mail_list: 'sem@sch.bme.hu',
             shortname: 'SEM').save


m = Member.new full_name: "Teszt Janos",
               email: "test1@test.cc",
               phone: "5550132",
               univ_year: 2010,
               enrollment_year: 2011,
               nick: "janika"
m.admin = true

m.set_login_attr "test"
m.save

szk_ms = szk.memberships.build from_date: 2.year.ago
szk_ms.accepted = true
szk_ms.member = m
szk_ms.save

ms = kirdev.memberships.build from_date: 1.year.ago
ms.member = m
ms.accepted = true
ms.save

# group admin for KirDev
role = MemberRole.new
role.name = "group_admin"
role.group_id = kirdev.id
role.save

# make test user group admin in KirDev
m.roles << role