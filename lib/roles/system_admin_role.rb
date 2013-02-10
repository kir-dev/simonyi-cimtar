require "acting_role"

class Roles::SystemAdminRole < ActingRole
  register_role :system_admin

  def name
    :system_admin
  end

  def global?
    true
  end

protected

  def check_inner(action, resource)
    false
  end

  def initialize_rules
    has_permission_to [:create, :update, :list], Group
    has_permission_to :manage, Post
    has_permission_to :manage, Membership
    has_permission_to :manage, Member
    has_permission_to :manage, Semester
    has_permission_to :manage, Role
    has_permission_to :edit, Valuation
  end
end
