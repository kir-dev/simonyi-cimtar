# encoding: UTF-8
# groups seed data

g = Group.create name: "KIR fejlesztők és üzemeltetők",
                 founded: 2001,
                 url: "http://kir-dev.sch.bme.hu",
                 mail_list: "kir-dev@sch.bme.hu",
                 shortname: "Kir-Dev"

m = Member.new full_name: "Teszt Janos",
               email: "test1@test.cc",
               phone: "5550132",
               univ_year: 2010,
               enrollment_year: 2011,
               nick: "janika"
m.admin = true               

m.set_login_attr "test"
m.save

# member is a group leader
ms = g.memberships.build from_date: 1.year.ago
ms.member = m;
ms.accepted = true
g.save

post = ms.posts.build title: "Körvezető", from_date: 6.months.ago
perm = post.permissions.build resource: "group"
perm.manage = true

post.save
perm.save
