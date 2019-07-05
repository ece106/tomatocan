require 'test_helper'
require 'capybara-screenshot/minitest'

class UserVisitsEventPage < ActionDispatch::IntegrationTest
  setup do
    @user  = users :one
    @event = events :one

    visit edit_event_path @event
  end

  test "visits edit event page successfully" do
    page.status_code == 200
  end

  test "visits edit event page unsuccessfully" do
    page.status_code == 400
  end

  test "can fill out the edit event form successfully" do
    page.has_css? "input#event_name"
    page.has_css? "input#event_desc"

    fill_in "name", with: "Test Event"
  end

end
