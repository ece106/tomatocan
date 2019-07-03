require 'test_helper'
require 'capybara-screenshot/minitest'

class UserVisitsEventPage < ActionDispatch::IntegrationTest

  setup do
    @user  = users(:one)
    @event = events(:one)
    @rsvpq = rsvpqs(:one)

    visit event_path(@event)
  end

  test "visits event page successfully" do
    page.status_code == 200
  end

  test "visits events page unsuccessfully" do
    page.status_code == 400
  end

  test "should see the correct event title" do
    page.has_content?(@event.name)
  end

  test "should see the correct event host" do
    page.has_content?(@user.name)
  end

  # TODO: Coming back to this
  test "should see the edit_event link" do
    page.has_link?(edit_event_path(@event))
    # page.click_on(edit_event_path(@event))
  end

  test "should see the correct start date" do
    page.has_content?(@event.start_at.strftime("%B %d, %Y"))
  end

  test "should see the correct start at timezones" do
    page.has_content?(@event.start_at.strftime("%I:%M %p"))
    page.has_content?((@event.start_at + 3).strftime("%I:%M %p"))
  end

  test "should see the correct duration" do
    # @duration = ((@event.end_at - @event.start_at) / 60).floor
    page.has_css?(".event-duration")
  end

end
