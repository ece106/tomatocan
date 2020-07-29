require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsAccountSettings < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit "/#{@test_user.permalink}/controlpanel"
  end

  test "user edits account settings with valid attributes" do

    find(class: "account-settings-tab", text: "Account").click

    fill_in id: "user_email", with: "test@mail.com"
    fill_in(id: "user_permalink", with: "test123")

    click_on class: "btn btn-primary save-acct-info-btn"

    assert_equal current_path, "/test123"
    assert page.has_content? "test@mail.com"
  end

  test "user changes password" do

    old_password = @test_user.encrypted_password

    find(class: "account-settings-tab", text: "Account").click

    click_on "Change Password"

    fill_in id: "user_password", with: "newpassword"
    fill_in(id: "user_password_confirmation", with: "newpassword")

    assert_equal current_path, "/#{@test_user.permalink}/changepassword"

    click_on "Save Profile"
    assert_equal current_path, "/#{@test_user.permalink}"

    @test_user.reload
    assert_not_equal(@test_user.encrypted_password, old_password)
  end

  test "user cancels edits account settings with same attributes" do
    find(class: "account-settings-tab", text: "Account").click

    click_on class: "btn btn-default cancel-acct-settings-btn"

    assert_equal current_path, "/#{@test_user.permalink}"
  end

  test "user saves edits account settings with same attributes" do
    find(class: "account-settings-tab", text: "Account").click

    click_on class: "btn btn-primary save-acct-info-btn"

    assert_equal current_path, "/#{@test_user.permalink}"
  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'thinqtesting@gmail.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end

