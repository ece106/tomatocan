require 'test_helper'

class RsvpqMailerTest < ActionMailer::TestCase
  setup do
    @rsvpq = rsvpqs(:one)
    @user  = users(:one)
  end

  test "rsvpq_created" do
    mail = RsvpqMailer.with(rsvpq: @rsvpq, user: @user).rsvpq_created

    assert_equal "Successfully created an RSVP.",   mail.subject
    assert_equal ["fake@fake.com"],                 mail.to
    assert_equal ["crowdpublishtv.star@gmail.com"], mail.from
  end

end
