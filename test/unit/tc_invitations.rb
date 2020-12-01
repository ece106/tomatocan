require 'test_helper'

class TestInvites < ActionController::TestCase

  def test_get_invitation_phone_number
    # United States number
    assert_equal( '+1555-123-4567', Invite.get_phone_number('555-123-4567', "US") )
    # Sudanese number
    assert_equal( '+249555-765-4321', Invite.get_phone_number('555-765-4321', "SD") )
    # Ukrainian number
    assert_equal( '+380555-987-6543', Invite.get_phone_number('555-987-6543', "UA") )
    # Vietnamese number
    assert_equal( '+84555-999-9999', Invite.get_phone_number('555-999-9999', "VN") )
    # Phone number validity check not performed in this stage. The below line would be successful as of the time of writing.
    #Invite.get_phone_number('ab37', "US")
    # Bad ISO code
    assert_raise( "UnknownCodeError" ) { Invite.get_phone_number('555-555-5555', "37") }
  end

  def test_get_invite_url
    assert_equal("https://thinq.tv/invite/137", Invite.get_invite_url( 137 ))
    # It should still work as a string.
    assert_equal("https://thinq.tv/invite/526", Invite.get_invite_url( "526" ))
  end

  def test_enumerate_relationship
    assert_equal(0, Invite.enumerate_relationship("Family"))
    assert_equal(1, Invite.enumerate_relationship("Friends"))
    assert_equal(3, Invite.enumerate_relationship("Coworkers"))
    assert_raise( "RuntimError" ) { Invite.enumerate_relationship("This should not be a valid relationship option.") }
  end

  def test_get_message
    message1 = Invite.get_message("Family", "Career Advice", "USERNAME", 731)
    message2 = Invite.get_message("Coworkers", "Career Advice", "USERNAME", 731)
    # Isolated variable: specified relationship
    assert_not_equal( message1, message2 )

    # Isolated variable: specified relationship when unsure of topic of interest
    message1 = Invite.get_message("Family", "I'm unsure", "USERNAME", 71)
    message2 = Invite.get_message("Coworkers", "I'm unsure", "USERNAME", 71)
    assert_not_equal( message1, message2 )

    # Isolated variable: topic of interest
    message1 = Invite.get_message("Family", "STEMinism", "USERNAME", 1412)
    message2 = Invite.get_message("Family", "Finding Employment at Thinq", "USERNAME", 1412)
    assert_not_equal( message1, message2 )

    # Isolated variable: sender id number
    message1 = Invite.get_message("Family", "Inclusivity in STEM", "USERNAME", 12)
    message2 = Invite.get_message("Family", "Inclusivity in STEM", "USERNAME", 1998)
    assert_not_equal( message1, message2 )
  end

  def test_create_referer_cookie
    inv_controller = InvitesController.new
    # Tests for an expected exception in response to bad input.
    assert_raise( "RuntimeError") { inv_controller.create_referer_cookie( "not_a_number" ) }
  end

end
