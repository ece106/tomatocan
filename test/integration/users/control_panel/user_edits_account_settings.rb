require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsAccountSettings < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    sign_in

    visit "/#{@user.permalink}/controlpanel"
  end

  test "user edits account settings with valid attributes" do
    binding.pry
  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end

