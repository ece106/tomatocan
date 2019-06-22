require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:two)
    @recipient = users(:one)
  end
  test "new_event mail to,from,subject" do

    event = Event.first_or_create
    mail = EventMailer.new_event(@recipient,event,@user)
    assert_equal "Someone you follow has created an event", mail.subject
    assert_equal [@recipient.email], mail.to
    assert_equal ["crowdpublishtv.star@gmail.com"], mail.from
  end

end
