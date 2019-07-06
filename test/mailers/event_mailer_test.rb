require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:two)
    @recipient = users(:one)
    @mail_hash = {recipient:@recipient,event:events(:one),user:@user}
  end


end
