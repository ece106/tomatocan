require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsAccountSettings < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    sign_in

    visit "/#{@user.permalink}/controlpanel"
  end

  test "user edits account settings with valid attributes" do
    test_permalink = "user123"

    find(class: "account-settings-tab", text: "Account").click

    fill_in id: "user_email", with: "test@mail.com"
    fill_in(id: "user_permalink", with: test_permalink)

    click_on class: "save-acct-info-btn"

    assert_equal current_path, "/#{test_permalink}"
  end

  test "user edits account settings with same attributes" do
    find(class: "account-settings-tab", text: "Account").click

    click_on class: "save-acct-info-btn"

    assert_equal current_path, "/#{@user.permalink}"
  end

  test "user cancels edits account settings with same attributes" do
    find(class: "account-settings-tab", text: "Account").click

    click_on class: "btn btn-default cancel-acct-settings-btn"

    assert_equal current_path, "/#{@user.permalink}"
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

