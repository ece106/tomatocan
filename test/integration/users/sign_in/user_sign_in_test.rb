require 'test_helper'

class UserSignInTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @event = events :one
  end

test "user signed in successfully" do
  sign_in do
  assert_no_text("Invalid email or password.")
  end
end

test "error message displayed" do
  fail_sign_in do
  page.find("div#flash_alert")
  end
end
test"error message has red background" do
  fail_sign_in do
  page.has_css?('.alert.alert-danger')
  end
end


def sign_in
  visit root_path

  click_on('Sign In', match: :first)

  fill_in(id: 'user_email', with: 'fake@fake.com')
  fill_in(id: 'user_password', with: 'user1234')

  click_on(class: 'form-control btn-primary')
end

  def fail_sign_in
    visit root_path
    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'wrong@wrong.com')
    fill_in(id: 'user_password', with: 'wrong1234')

    click_on(class: 'form-control btn-primary')
  end
end