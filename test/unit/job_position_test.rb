require 'test_helper'

class JobPositionTest < ActiveSupport::TestCase

  setup do
    @job = job_positions :microsoft
  end

  test "when job position has present_job flag and to_date specified" do
    @job.to_date = 2.days.from_now

    assert @job.present_job
    assert_not @job.valid?
    assert_equal 1, @job.errors.size
  end

  test "when job position is not a present_job but does not have to_date" do
    @job.present_job = nil

    assert_not @job.valid?
    assert_equal 1, @job.errors.size
  end

  test "when job position has to_date and it is before from_date" do
    @job.present_job = false
    @job.to_date = Date.new 1999, 12, 12

    assert_not @job.valid?
    assert_equal 1, @job.errors.size
  end

  test "when to_date is after today" do
    @job.present_job = false
    @job.to_date = 2.days.from_now

    assert_not @job.valid?
    assert_equal 1, @job.errors.size
  end

end
