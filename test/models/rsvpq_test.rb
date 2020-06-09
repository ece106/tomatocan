require 'test_helper'

class RsvpqTest < ActiveSupport::TestCase

  def setup
    @rsvpq = rsvpqs(:one)
    @rsvpq2 = rsvpqs(:two)
  end

  [:event_id].each do |field|
    test "#{field}_must_not_be_empty" do
      @rsvpq.send "#{field}=", nil
      refute @rsvpq.valid?
      refute_empty @rsvpq.errors[field]
    end
    end
  [:email].each do |field|
    test 'test_email' do
    email_entry =  'this@@@@email@@@@.wontwork.'
    @rsvpq.send "#{field}=", email_entry
    refute @rsvpq.valid?
    end
  end


  test 'rsvp must have a unique combonation of user_id, event_id and email values' do
    @rsvpq.user_id = 1
    @rsvpq.event_id = 1
    @rsvpq.email = nil

    @rsvpq2.user_id = 1
    @rsvpq2.event_id = 1
    @rsvpq2.email = nil

    @rsvpq.save

    refute @rsvpq2.valid?, 'saved rsvp that already exists'
  end

end