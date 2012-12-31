require 'test_helper'

class MemberAbilitiesTest < ActiveSupport::TestCase

  test "user can manage groups when he is the group leader" do
    user, ability = create_user_and_ability :user_as_group_leader

    assert ability.can?(:manage, user.groups.first), "should be able to manage that group"
    
  end

  test "user can update himself" do
    user, ability = create_user_and_ability :user
    assert ability.can?(:update, user)
  end

  test "user cannot update an other user" do
    user, ability = create_user_and_ability :user
    other_user = FactoryGirl.create :user, :email => "a@b.com", :login => "test-new"

    assert ability.cannot?(:update, other_user)
  end

  test "average user cannot delete an other user" do
    user, ability = create_user_and_ability :user
    other_user = FactoryGirl.create :user, :email => "a@b.com", :login => "test-new"

    assert ability.cannot?(:destroy, Member)
    assert ability.cannot?(:destroy, other_user)
  end

  test "admins have full control over members" do
    pending "nobody is admin at the moment..."
  end

end
