require "test_helper"
require "capybara-screenshot/minitest"

class UserVisitsControlPanelShowsPage < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    visit "/#{@user.permalink}/controlpanel"
  end

  test "flunk" do
    binding.pry
  end
end
