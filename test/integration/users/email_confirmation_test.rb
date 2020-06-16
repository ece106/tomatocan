require 'test_helper'

class Users::EmailConfirmationTest < ActionDispatch::IntegrationTest
  setup do

    @newUser = {name: "newUser", email: "newUser@gmail.com", permalink: "newUser",
    password: "thisIsANewUser", password_confirmation: "thisIsANewUser"}
  end

  test "confirmation sent" do
    visit new_user_signup_path
    assert_emails 1 do
      user_sign_up @newUser
    end
    assert_equal current_path, new_user_session_path
    assert have_text("You have to confirm your account before continuing.")
  end

  test "signin with unconfirmed email" do

  end

  test "resend confirmation" do

  end

  test "change email" do

  end
end
