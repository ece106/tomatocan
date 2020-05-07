require 'test_helper'

class RsvpMailerTest < ActionMailer::TestCase

  def setup
    @event = Event.find(1)
    @user = User.first
    @email = "test@test.com"
    @timeZone = "1:00 PM"
  end

  test 'thanks for rsvp' do
    email = RsvpMailer.with(user: @user, event: @event, timeZone: @timeZone).rsvp_reminder
    email_2 = RsvpMailer.with(email: @email, event: @event, timeZone: @timeZone).rsvp_reminder

    assert_emails 1 do
      email.deliver_later
    end
    assert_emails 1 do
      email_2.deliver_later
    end

    assert_equal email.to, [@user.email]
    assert_equal email_2.to, [@email]
    assert_equal email.from, ['info@ThinQ.tv']
    assert_equal email_2.from, ['info@ThinQ.tv']
    assert email.subject.include?('A reminder for your ThinQ.tv Conversation on')
    assert email_2.subject.include?('A reminder for your ThinQ.tv Conversation on')
  end
end
