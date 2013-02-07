require "test_helper"

class ActingRoleTest < ActiveSupport::TestCase
  
  test "list all the registered roles" do
    assert ActingRole.roles.include?(:group_admin)
  end

  test "adding new roles" do
    ActingRole.register_role :group_leader, Roles::GroupAdminRole

    assert ActingRole.roles.include?(:group_leader)
    assert ActingRole.create_role(:group_leader, nil).is_a?(Roles::GroupAdminRole)
  end

  test "trying to create a not registered role" do
    role = ActingRole.create_role(:non_existent, nil)

    assert_not_nil role
    assert role.is_a? ActingRole
  end

  test "ActingRole says false for every check" do
    role = ActingRole.new nil, nil

    [:read, :create, :some_action, :some_other_action].each do |a|
      assert_not role.check(a, nil, nil)
    end
  end

  test "ActingRole constant must be loaded" do
    assert_nothing_raised do
      ActingRole
    end
  end

end