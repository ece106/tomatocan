require "test_helper"
require "capybara-screenshot/minitest"

class UserChangesPassword < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    sign_in

    visit "/#{@user.permalink}/changepassword"
  end

  test "user changes password with valid attributes" do

    # find(class: "account-settings-tab", text: "Change password").click

    fill_in id: "user_password", with: "newpass"
    fill_in(id: "user_password_confirmation", with: "newpassconfirmation")

    click_on "Save Profile"

    assert_equal current_path, "/#{@user_permalink}"
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
