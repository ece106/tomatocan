require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsProfile < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    sign_in

    visit "/#{@user.permalink}/controlpanel"
  end

  test "can edit profile page with correct attributes" do
    fill_in id: "user_name", with: "Cody Karunas"
    fill_in id: "user_about", with: "About me description"
    fill_in id: "user_genre1", with: "Topic 1"
    fill_in id: "user_genre2", with: "Topic 2"
    fill_in id: "user_genre3", with: "Topic 3"

    find("input[name='commit']", match: :first).click

    assert page.has_content? "Cody Karunas"
    assert page.has_content? "Topic 1"
    assert page.has_content? "Topic 2"
    assert page.has_content? "Topic 3"
  end

  test "can cancel edit profile page" do
    find(id: "cancelProfileButton", match: :first).click
  end

  test "can save edit profile page" do 
    find(id: "saveProfileButton", match: :first).click
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
