require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  
  setup do
    @user = users(:one)
    @mail_hash = {event: events(:one),user: @user}
  end
  
  test 'to, from' do
    mail = EventMailer.with(@mail_hash).event_reminder
    assert_equal ["#{@user.email}"] , mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
  end
end
