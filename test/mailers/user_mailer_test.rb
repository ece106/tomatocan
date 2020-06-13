require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
	@mail_check = {event: events(:one),user: @user}
  end
  
  #As of June 2, 2020 all tests pass
  
#Tests if an email is sent to the user after signing up.
#Checks if it has the correct subject
#Checks if it was mailed to the correct person
#Checks if the email was sent from the correct email
#Checks body of the email
  test 'welcome email to,from,subject' do
    mail = UserMailer.with(user: @user).welcome_email
    assert_equal "Welcome", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
	assert_equal "", mail.body.to_s
  end
  
  #sends an email and checks if it got queued
  test 'delivery check' do
	
	mail = UserMailer.with(user: @user).welcome_email
	
	assert_emails 1 do
		mail.deliver_later
	end
	
  end
  
end