require 'test_helper'

class MemberRoleTest < ActiveSupport::TestCase

  test "member_role has many members" do
    user = FactoryGirl.create :user

    role = MemberRole.new name: "admin"
    role.members << user
    role.save

    assert_equal 1, role.members.size
    assert_equal 1, user.roles.size
  end
end
