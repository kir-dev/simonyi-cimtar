require "test_helper"

class MemberTest < ActiveSupport::TestCase
  
  test "member can turn its role into acting roles" do
    user = FactoryGirl.create :user
    user.roles.create name: "group_admin"

    roles = user.get_acting_roles
    
    assert_not_nil roles
    assert_equal 1, roles.size
    assert_not roles[0].class == ActingRole, "user's role is an ActingRole, but it should be that one"
    assert roles[0].is_a?(Roles::GroupAdminRole), "user's role in not a GroupAdminRole"

  end
end