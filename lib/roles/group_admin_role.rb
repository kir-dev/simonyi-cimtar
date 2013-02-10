require "acting_role"

class Roles::GroupAdminRole < ActingRole
  register_role :group_admin

  def name
    :group_admin
  end

  def global?
    false
  end

protected

  def check_inner(action, resource)
    false
  end

  def initialize_rules
    has_permission_to :update, Group
    has_permission_to :manage, Post
    has_permission_to :manage, Membership
    has_permission_to :edit, Valuation
  end
end
