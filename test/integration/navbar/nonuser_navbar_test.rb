require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class NonuserNavbar < ActionDispatch::IntegrationTest
  setup do
    @user = {name: "fake_name", email: "newfake@fake.com", permalink: "fake_user",
       password: "fake_password", password_confirmation: "fake_password"}
    @confirmedUser = users :confirmedUser
    visit root_path
  end

  test 'navitem buttons' do
    assert page.has_css? '.nav-item'
    assert page.has_link? 'Home'
    first(:xpath, "//a[@href='/']").click
    assert_equal '/', current_path
    assert page.has_link? 'About Us'
    find_link('About Us', match: :first).click
    first(:xpath, "//a[@href='/getinvolved']").click
    assert page.has_link? 'Join the Team'
    first(:xpath, "//a[@href='/jointheteam']").click
    assert_equal '/jointheteam', current_path
    assert page.has_link? 'Drop in Anytime'
    first(:xpath, "//a[@href='/studyhall']").click
    assert_equal '/studyhall', current_path
  end

  test 'sign up' do
    assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign Up'
    find_link('Sign Up', match: :first).click
    assert_equal '/signup', current_path
    assert_emails 2 do
        #Confirmation email is sent after signup
      user_sign_up @user
    end
    assert_equal '/login', current_path
  end

  test 'sign in' do
    assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign In'
    find_link('Sign In', match: :first).click
    assert_equal '/login', current_path
    user_sign_in @confirmedUser
    assert_equal '/', current_path
    click_on class: 'btn btn-primary border-warning text-warning', match: :first
  end
end
