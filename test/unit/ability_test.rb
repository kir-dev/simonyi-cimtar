require "test_helper"

class AbilityTest < ActiveSupport::TestCase
  
  test "overridden authorize! method does not change the basic behaviour" do
    user, ability = create_user_and_ability :user_with_job

    # members can create and update their own job positions
    assert_nothing_raised { ability.authorize! :create, JobPosition }
    assert_nothing_raised { ability.authorize! :update, user.job_positions.first }

    # average members cannot create other members
    assert_raise(CanCan::AccessDenied){ ability.authorize! :create, Member }
  end

  test "authorized ability with a given group" do
    user, ability = create_user_and_ability :user_as_group_leader

    assert_nothing_raised { ability.authorize! :create, MemberPost, user.groups.first }
  end

  test "transform subject into resource" do
    a = Ability.new nil # does not need a user for this

    s1 = a.transform_subject_to_resource MemberPost
    s2 = a.transform_subject_to_resource MemberPost.new

    assert_equal "member_post", s1
    assert_equal "member_post", s2
  end

  test "transform action into ability" do
    a = Ability.new nil # does not need a user for this
    
    a1 = a.transform_action_to_ability :create
    a2 = a.transform_action_to_ability :show
    
    a.alias_action :update, :to => :modify
    a3 = a.transform_action_to_ability :modify

    assert_equal :create, a1
    assert_equal :read, a2
    assert_equal :update, a3
  end

end