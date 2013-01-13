require 'test_helper'

class JobPositionAbilitiesTest < ActiveSupport::TestCase
  
  test "user can create job_positon" do
    user, ability = create_user_and_ability :user
    assert ability.can?(:create, JobPosition)
  end

  test "user can modify his job positions" do
    user, ability = create_user_and_ability :user_with_job
    job = user.job_positions.first

    assert ability.can?(:update, job)
  end

  test "user can delete previous jobs" do
    user, ability = create_user_and_ability :user_with_job
    job = user.job_positions.first

    assert ability.can?(:destroy, job)
  end

  test "a user cannot modify an other user's jobs" do
    user, ability = create_user_and_ability :user
    other_user = FactoryGirl.create :user_with_job, :email => "a@b.com", :login => "test-new"
    job = other_user.job_positions.first

    assert ability.cannot?(:update, job)
    assert ability.cannot?(:destroy, job)
  end

  test "everybody can read job_positions" do
    user = FactoryGirl.create :user_with_job
    job = user.job_positions.first
    average_joe = Member.new

    ability = Ability.new average_joe
    assert ability.can?(:read, job)
  end

end