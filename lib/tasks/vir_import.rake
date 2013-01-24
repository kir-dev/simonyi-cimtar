require "rubygems"
require "sequel"

DB = Sequel.connect('postgres://kir:alma123@localhost/vir')

# map groups: virdb<->szkcimtar
# iterate through the members of the SZK group in virdb - are they in the CSV? (neptun, mail check)
# -- member is in the CSV:
# -- -- member is not in szkcimtar db
#			* save new member with the given data (CSV+virdb)
# 			* save SZK group membership with the proper 'from' date
# -- -- szkcimtar db already contains the member: save the given group membership with proper date
# körök aktív tagjain is végigmenni a fenti logika szerint
# iterate through the members of other groups in virdb with the logic described above
def test
	DB.fetch("SELECT * FROM users limit 10") do |row|
		puts row[:usr_id]
	end
end

desc "Import members from the crossreferenced VIRDb and csv"
task :vir_import do
	time_begin = Time.now
	puts "begin "
	test
	puts "end... elapsed time=" + (Time.now - time_begin).to_s
end