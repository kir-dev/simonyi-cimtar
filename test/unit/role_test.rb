require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  test "role has many members" do
    user = FactoryGirl.create :user

    role = Role.new name: "admin"
    role.members << user
    role.save

    assert_equal 1, role.members.size
    assert_equal 1, user.roles.size
  end
end
