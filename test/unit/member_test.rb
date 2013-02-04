require "test_helper"

class MemberTest < ActiveSupport::TestCase
  
  test "member can turn its role into acting roles" do
    user = FactoryGirl.create :user
    user.roles.create name: "group_admin"

    roles = user.get_acting_roles
    
    assert_not_nil roles
    assert_equal 1, roles.size
    assert roles[0].is_a?(GroupAdmin), "user's role in not a GroupAdmin"

  end
end