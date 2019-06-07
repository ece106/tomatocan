require 'test_helper'

class RsvpqTest < ActiveSupport::TestCase

  def setup
    @rsvpq = rsvpqs(:one)
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
end