require './app/models/member'

class VirMember < Member
	attr_accessor :neptun, :vir_id # transient fields
end