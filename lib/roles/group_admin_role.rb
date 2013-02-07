require "acting_role"

class Roles::GroupAdminRole < ActingRole
  register_role :group_admin

  def name
    :group_admin
  end

  def global?
    false
  end

end
