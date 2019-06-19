require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  @user =
  test "welcome email content" do
    mail = Usermailer.welcome_email(@user)
    assert_equal "Welcome", mail.subject
    assert_equal "" ,mail.to
    assert_equal "", mail.from
    assert_equal "", mail.body.encoded

  end
end
