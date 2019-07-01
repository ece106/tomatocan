require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:two)
    @recipient = users(:one)
    @mail_hash = {recipient:@recipient,event:events(:one),user:@user}
  end
  test "new_event mail to,from,subject" do
    mail = EventMailer.with(@mail_hash).new_event
    assert_equal "Someone you follow has created an event", mail.subject
    assert_equal [@recipient.email], mail.to
    assert_equal ["crowdpublishtv.star@gmail.com"], mail.from
  end

end
