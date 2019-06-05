require 'test_helper'

class TimeslotTest < ActiveSupport::TestCase

  def setup
    @time = Timeslot.new(user_id: users(:one).id, start_at: Time.now, end_at: Time.now+30.minute)
  end

  test "end at is greater than start at " do
    isTrue = true
    if @time.end_at < @time.start_at
      isTrue = false
    end
    assert (isTrue)
  end

  test "should require user id" do
    isTrue = true
    if @time.user_id == nil
      isTrue = false
    end
    assert (isTrue)
  end

  test "the truth" do
    assert true
  end

end
