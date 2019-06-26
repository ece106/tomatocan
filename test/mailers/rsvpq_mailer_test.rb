require 'test_helper'

class RsvpqMailerTest < ActionMailer::TestCase
  setup do
    @user  = users(:one)
    @event = events(:one)
  end

  test "rsvpq_created" do
    mail = RsvpqMailer.with(rsvpq: @rsvpq, user: @user).rsvpq_created

    assert_equal "Rsvpq created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
  end

end
