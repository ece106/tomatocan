require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
  end
  test 'welcome email to,from,subject' do
    mail = UserMailer.with(user: @user).welcome_email
    assert_equal "Welcome", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
end 
