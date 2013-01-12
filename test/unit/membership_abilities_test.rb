require "test_helper"

class MembershipAbilitiesTest < ActiveSupport::TestCase

  test "anybody can join a group" do
    user, ability = create_user_and_ability :user

    assert ability.can?(:create, Membership)
  end

  test "memberships can only be updated by group leaders" do
    user, ability = create_user_and_ability :user_as_group_leader
    other_user = FactoryGirl.create :user, :email => "a@b.com", :login => "test-new"
    membership = Membership.new
    membership.group = user.groups.first
    membership.member = other_user
    membership.from_date = Date.today

    assert ability.can?(:update, membership, membership.group)
    assert Ability.new(other_user).cannot?(:update, membership, membership.group)
    
  end
  
end