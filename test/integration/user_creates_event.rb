require 'test_helper'
require 'capybara-screenshot/minitest'

class UserCreatesEvent < ActionDispatch::IntegrationTest

  setup do
    @user  = users(:one)
    @event = events(:one)
  end

  test "users visits event page successfully" do
    visit event_path(@event)

    page.status_code == 200
  end

  test "visits events page unsuccessfully" do
    visit event_path(@event)

    page.status_code == 400
  end

  test "expects to see a button" do
    visit event_path(@event)

    page.has_css?('.btn')
  end
end
