require 'test_helper'

class EventMailerTest < ActionMailer::TestCase
  test "new_event mail to,from,subject" do
    user = User.new(name: 'user', password: "userpassword",
                        password_confirmation: "userpassword",
                        email: "email@email.com", permalink: "perma", id: 111)
    recipiant = User.last
    event = Event.first_or_create
    mail = EventMailer.new_event(recipiant,event,user)
    assert_equal "Somone you follow has created an event", mail.subject
    assert_equal [recipiant.email], mail.to
    assert_equal ["crowdpublishtv.star@gmail.com"], mail.from
  end

end
