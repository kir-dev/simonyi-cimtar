require 'test_helper'

class MemberTest < ActiveSupport::TestCase

  test "user can manage groups when he is the group leader" do
    user = FactoryGirl.create :user_as_group_leader
    ability = Ability.new user

    assert ability.can?(:manage, user.groups.first), "should be able to manage that group"
    
  end

end
