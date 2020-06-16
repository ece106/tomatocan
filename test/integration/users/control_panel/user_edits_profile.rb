require 'test_helper'
require 'capybara-screenshot/minitest'

class UserEditsProfile < ActionDispatch::IntegrationTest
  setup do
    @user = users :one

    sign_in

    visit "/#{@user.permalink}/controlpanel"
  end

  test "can edit profile page with correct attributes" do
    fill_in id: "user_name", with: "Cody Karunas"
    fill_in id: "user_about", with: "About you"
    fill_in id: "user_genre1", with: "Test Category"
    fill_in id: "user_genre2", with: "Test Category"
    fill_in id: "user_genre3", with: "Test Category"

    find("input[name='commit']", match: :first).click

    assert page.has_content? "Cody Karunas"
    assert page.has_content? "Test Category"
    assert page.has_content? "Test Category"
  end

  test "can cancel edit profile page" do
    find(id: "cancelProfileButton", match: :first).click
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
