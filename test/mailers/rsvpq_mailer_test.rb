require 'test_helper'

class RsvpqMailerTest < ActionMailer::TestCase
  setup do
  end

  test "rsvpq_created" do
    mail = RsvpqMailer.rsvpq_created

    assert_equal "Rsvpq created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from

    assert_match "Hi", mail.body.encoded
  end

end
