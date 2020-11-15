require 'test_helper'
#tests for sign in error message upon failed sign in - blake
class UserSignInTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @event = events :one

    fail_sign_in
  end

  test "error message did not display" do
    assert page.has_css?('.alert', text: 'Invalid email or password', visible: true)
    end

  #message represents what case is if test fails
  test"error message has no red background" do
    assert page.has_css?('.alert.alert-danger')
    end
end

def fail_sign_in
  visit root_path
  click_on('Sign In', match: :first)

  fill_in(id: 'user_email', with: 'wrong@wrong.com')
  fill_in(id: 'user_password', with: 'wrong1234')

  click_on(class: 'form-control btn-primary')
end
