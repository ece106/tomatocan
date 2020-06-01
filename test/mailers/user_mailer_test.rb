require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
  end
  
#Tests if an email is sent to the user after signing up.
#Checks if it has the correct subject
#Checks if it was mailed to the correct person
#Checks if the email was sent from the correct email
  test 'welcome email to,from,subject' do
    mail = UserMailer.with(user: @user).welcome_email
    assert_equal "Welcome", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
  end
end
