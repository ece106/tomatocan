require_relative "../test_helper"
# require_relative "../../app/controllers/invites_controller"
# require "test/unit"

class TestInvites < Test::Unit::TestCase

  def test_get_invitation_phone_number
    # United States number
    assert_equal( '+1555-123-4567', InvitesController.get_phone_number('555-123-4567', 3166) )
  end


  private

  def _setup(attributes = {})
    #return Invite.initialize(attributes)
    #:invite => Invite.initialize(attributes)
  end

#  def invite_params
#      params.require(:invite).permit(:phone_number, :country_code, :relationship, :interest, :preferred_name, :sender_id)
#  end
end

