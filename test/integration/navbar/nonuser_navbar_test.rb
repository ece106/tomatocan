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
    find_link('Home', match: :first).click
    assert_equal '/', current_path
    assert page.has_link? 'Discover Previous Conversations'
    find_link('Discover Previous Conversations', match: :first).click
    assert_equal '/supportourwork', current_path
    assert page.has_link? 'Invite Us To Speak'
    find_link('Invite Us To Speak', match: :first).click
    assert_equal '/drschaeferspeaking', current_path
    assert page.has_link? 'Be a ThinQtv Influencer!'
    find_link('Be a ThinQtv Influencer!', match: :first).click
    assert_equal '/internship', current_path
    assert page.has_link? 'FAQ'
    find_link('FAQ', match: :first).click
    assert_equal '/faq', current_path
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
    click_on class: 'btn btn-default', match: :first
  end
end
