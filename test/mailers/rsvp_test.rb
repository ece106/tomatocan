require 'test_helper'

class RsvpMailerTest < ActionMailer::TestCase

#As of June 2, 2020 all tests work
#Getting a DEPRECATION WARNING:but that should not be an issue unless the website begins to use rails 6.1

  def setup
    @event = Event.find(1)
    @user = User.first
    @email = "test@test.com"
    @timeZone = "1:00 PM"
  end

  test 'thanks for rsvp' do
    email = RsvpMailer.with(user: @user, event: @event, timeZone: @timeZone).rsvp_reminder
    email_2 = RsvpMailer.with(email: @email, event: @event, timeZone: @timeZone).rsvp_reminder

    #Sends the emails and then tests if emails got queued
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
  

  #Test makes sure that user cannot rsvp without putting in an email.
  test 'Not signed rsvp' do
	email_empty = RsvpMailer.with(user: '', event:@event, timeZone: @timeZone).rsvp_reminder
	
	email_empty.deliver_later
	
	assert_no_emails
  end
	
	
end
