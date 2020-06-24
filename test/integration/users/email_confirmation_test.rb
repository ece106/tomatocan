require 'test_helper'

class Users::EmailConfirmationTest < ActionDispatch::IntegrationTest
  setup do
    @newUser = {name: "newUser", email: "newUser@gmail.com", permalink: "newUser",
    password: "thisIsANewUser", password_confirmation: "thisIsANewUser"}

    @unconfirmedUser = users :unconfirmedUser
    @confirmedUser = users :confirmedUser
  end

  test "confirmation sent" do
    visit new_user_signup_path
    assert_emails 2 do
      user_sign_up @newUser
    end
    assert_equal current_path, new_user_session_path
    assert find(class: "alert-success").has_text?("You have successfully signed up! An email has been sent for you to confirm your account.")
  end

  test "signin with unconfirmed email" do
    user_sign_in @unconfirmedUser
    assert find(class: "alert-danger").has_text?("You have to confirm your account before continuing.")
  end

  test "Email confirmed messasge" do
    confirmationEmailToken = "/confirmation?confirmation_token=#{@unconfirmedUser.confirmation_token}"
    visit confirmationEmailToken
    assert_equal current_path, new_user_session_path
    assert find(class: "alert-success").has_text?("Your account was successfully confirmed.")
    visit confirmationEmailToken
    assert_equal current_path, user_confirmation_path
    assert find(class: "alert-danger").has_text?("Email was already confirmed, please try signing in")
  end

  test "resend confirmation" do
    visit new_user_session_path
    find_link("Resend").click
    assert_equal current_path, new_user_confirmation_path
    fill_in "Email", with: @unconfirmedUser.unconfirmed_email
    assert_emails 1 do
      click_on class: "form-control btn-primary"
      assert_equal current_path, new_user_session_path
    end
    assert find(class: "alert-success").has_text?("You will receive an email with instructions about how to confirm your account in a few minutes.")
  end

  test "change email" do
    user_sign_in @confirmedUser
    visit "/#{@confirmedUser.permalink}/controlpanel"
    find(class: "account-settings-tab").click
    newEmail = "newEmail@gmail.com"
    within(id: "accountTab") do
      find(id: "user_email").fill_in with: newEmail
      assert_emails 1 do
        find(id: "saveProfileButton").click
      end
    end
    assert_equal current_path, "/#{@confirmedUser.permalink}"
    assert find(class: "alert-info").has_text?("A confirmation message for your new email has been sent to: #{newEmail} to save changes confirm email first");
  end
end
