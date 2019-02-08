require 'test_helper'

class RsvpqTest < ActiveSupport::TestCase

  def setup
    @rsvpq = rsvpqs(:one)
  end
 #if signed in, needs user id
 #if not then email
  [:event_id].each do |field|
    test "#{field}_must_not_be_empty" do
      @rsvpq.send "#{field}=", nil
      refute @rsvpq.valid?
      refute_empty @rsvpq.errors[field]
    end
  end
end
