require "test_helper"
require "capybara-screenshot/minitest"

class UserChangesPassword < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit "/#{@test_user.permalink}/changepassword"
  end

  test "user changes password with valid attributes" do

    fill_in id: "user_password", with: "newpassword"
    fill_in(id: "user_password_confirmation", with: "newpassword")

    assert page.has_content? "newpassword"

    click_on "Save Profile"

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
