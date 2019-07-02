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
    page.has_css?('.col-12 .col-md-8')
    page.has_css?('h1')

    page.has_content?(@event.name)
  end

  test "should see the correct event host link" do
    page.has_link?('a')
    page.has_content?(@user.name)
  end

  test "should see the correct start time" do
    page.has_content?(@event.start_at.strftime("%B %d, %Y"))
  end

end
