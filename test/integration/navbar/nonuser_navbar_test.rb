require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class NonuserNavbar < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    
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
    sign_up
    assert_equal '/fake_user/profileinfo', current_path
    click_on class: 'btn btn-default', match: :first
  end

  test 'sign in' do
    assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign In'
    find_link('Sign In', match: :first).click
    assert_equal '/login', current_path
    user_sign_in @user
    assert_equal '/', current_path
    click_on class: 'btn btn-default', match: :first
  end
  
  private
  def sign_up
    visit root_path

    click_on class: 'btn btn-primary'
    
    fill_in id: 'user_name', with: "fake_name"
    fill_in id: 'user_email',    with:  "newfake@fake.com"
    fill_in id: 'user_permalink', with: "fake_user"
    fill_in id: 'user_password', with: "fake_password"
    fill_in id: 'user_password_confirmation', with: "fake_password"

    click_on class: 'form-control btn-primary'
  end
  
  def teardown 
  end
end
