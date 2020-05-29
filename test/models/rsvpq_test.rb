require 'test_helper'

class RsvpqTest < ActiveSupport::TestCase

  setup do
    @rsvpqT = Rsvpq.find(1)
  end

  test "event_id_must_not_be_empty" do
    @rsvpqT.event_id = nil
    assert_not @rsvpqT.valid?, "Empty event_id accepted"

    @rsvpqT.event_id = rsvpqs(:valid_rsvpq_two).event_id
    assert @rsvpqT.valid?, "Valid event_id not accepted"
  end

  test 'test_email' do
    #Email format test
    email_entry =  'this@@@@email@@@@.wontwork.'
    @rsvpqT.email = email_entry
    assert_not @rsvpqT.valid?, "Invalid email format accepted"
    #Email presence test
    @rsvpqT.email = "thisIsmyEmail@gmail.com"
    @rsvpqT.user_id = nil
    assert @rsvpqT.valid?, "email present when user_id absent should be valid"
  end
end
