require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  test "new_event" do
    mail = EventMailer.new_event
    assert_equal "New event", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
