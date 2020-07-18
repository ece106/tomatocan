require 'test_helper'

class RsvpqTest < ActiveSupport::TestCase


  setup do
    @rsvpqT = Rsvpq.find(1)
  end

  test "validate presence of event_id" do
    # test event_id is empty
    @rsvpqT.event_id = nil
    assert_not @rsvpqT.valid?, "Empty event_id accepted"

    # test event_id is valid
    @rsvpqT.event_id = rsvpqs(:valid_rsvpq_two).event_id
    assert @rsvpqT.valid?, "Valid event_id not accepted"
  end

  test "validate format of email" do
    #Email valid format test
    @rsvpqT.email = 'validemail@gmail.com'
    assert @rsvpqT.valid? "Valid email not accepted"

    #Email invalid format test
    email_entry =  'this@@@@email@@@@.wontwork.'
    @rsvpqT.email = email_entry
    assert_not @rsvpqT.valid?, "Invalid email format accepted"
  end

  test "validate presence of email" do
    #Email valid presence test
    @rsvpqT.email = "thisIsmyEmail@gmail.com"
    @rsvpqT.user_id = nil
    assert @rsvpqT.valid?, "email present when user_id absent should be valid"

    #Email invalid presence test
    @rsvpqT.email = nil
    @rsvpqT.user_id = rsvpqs(:valid_rsvpq_one).user_id
    assert @rsvpqT.valid? "Empty email accepted"
  end
end
