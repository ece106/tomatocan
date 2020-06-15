require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  
  #As of June 2, 2020 all tests work
  #Getting a DEPRECATION WARNING:but that should not be an issue unless the website begins to use rails 6.1
  
  setup do
    @user = users(:one)
    @mail_hash = {event: events(:one),user: @user}
  end
  
  test 'to, from' do
    mail = EventMailer.with(@mail_hash).event_reminder
    assert_equal ["#{@user.email}"] , mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
  end
  
  #Checks the content of the email such as subject and body
  test 'content' do
	mail_cont = EventMailer.with(@mail_hash).event_reminder
	
	assert_emails 1 do
		mail_cont.deliver_now
	end
	
	assert mail_cont.subject.include?("A reminder for your ThinQ.tv Conversation on ")
	assert_equal "", mail_cont.body.to_s
  end
  
  #sends an email and checks if it got queued
  test 'Delivery check' do
	
	mail = EventMailer.with(@mail_hash).event_reminder
	
	assert_emails 1 do
		mail.deliver_later
	end
	
  end
  
end
