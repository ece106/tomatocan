require "test_helper"
require "capybara-screenshot/minitest"

class UserVistsEventShowPage < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    visit "/#{@user.permalink}/controlpanel"
  end

  test "user visits event show page on control panel" do
    visit "/#{@user.permalink}/controlpanel"
    binding.pry
  end

end
