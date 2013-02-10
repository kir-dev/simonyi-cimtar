require "acting_role"

class UserRole < ActingRole

  def name
    :user
  end

  def global?
    true
  end

protected

  def check_inner(action, resource)
    return check_member_permissions(action, resource) if resource.is_a? Member
    # TODO: check valuations too
  end

private

  MEMBER_ACTIONS = [:update, :edit]

  def check_member_permissions(action, member)
    return false unless MEMBER_ACTIONS.include? action

    # members only can update themselves
    user.id == member.id
  end

end