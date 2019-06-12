require 'test_helper'

class WelcomeMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  @user = users(:one)
  test "welcome email sends" do
    WelcomeMailer.welcome_email(@user).deliver_later
    database_mailbox = ActionMailer::Base.deliveries.size
    assert_not_empty database_mailbox
  end
end
