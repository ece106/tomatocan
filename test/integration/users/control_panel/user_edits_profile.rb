require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsProfile < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit "/#{@test_user.permalink}/controlpanel"
  end

  test "can edit profile page with correct attributes" do

    find(class: "profile-settings-tab", text: "Profile").click

    fill_in id: "user_name", with: "Test Name"
    fill_in id: "user_about", with: "About me"
    fill_in id: "user_genre1", with: "Test Topic 1"
    fill_in id: "user_genre2", with: "Test Topic 2"
    fill_in id: "user_genre3", with: "Test Topic 3"
  end

  test "can cancel edit profile page" do
    find(class: "profile-settings-tab", text: "Profile").click

    first(:id, "cancelProfileButton").click

    assert_equal current_path, "/#{@test_user.permalink}"
  end

  test "can save edit profile page" do
    find(class: "profile-settings-tab", text: "Profile").click

    first(:id, "saveProfileButton").click

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
