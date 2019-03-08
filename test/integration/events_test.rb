require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
  def setup
      @event = events(:one)
      @event = events(:two)
  end
      
     test "events should have create button on home" do
        get '/'
        assert_select 'h2', 'Host Interactive Livestream Discussions To Engage With Your Audience'
     end
     test "Should display events" do
       visit event_path
     end
end
