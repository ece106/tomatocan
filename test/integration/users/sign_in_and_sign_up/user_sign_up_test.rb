require 'test_helper'
#tests for sign in error message upon failed sign in - blake
class UserSignInTest < ActionDispatch::IntegrationTest
  setup do
    visit '/signup'
  end

  test "successfully sign up" do
      fill_in id: 'user_name', with: "userName"
      fill_in id: 'user_email',    with:  "user@mail.com"
      fill_in id: 'user_permalink', with: "useruseruser"
      fill_in id: 'user_password', with: "12345678"
      fill_in id: 'user_password_confirmation', with: "12345678"

      click_on class: 'form-control btn-primary'
      assert page.has_text? "You have successfully signed up! An email has been sent for you to confirm your account."
      assert_equal current_path, '/login'
  end

  test "unsuccessfully sign up" do
      fill_in id: 'user_name', with: "userName"
      fill_in id: 'user_email',    with:  ""
      fill_in id: 'user_permalink', with: "useruseruser"
      fill_in id: 'user_password', with: "12345678"
      fill_in id: 'user_password_confirmation', with: "12345678"

      click_on class: 'form-control btn-primary'
      assert page.has_text? "Email can't be blank"
      assert_equal current_path, '/signup'
  end

end
