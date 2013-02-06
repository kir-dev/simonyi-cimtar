class GroupAdmin < ActingRole

  register_role :group_admin

  def name
    :group_admin
  end

  def global?
    false
  end

  def check(action, resource)
    false
  end

end