require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class NonuserNavbar < ActionDispatch::IntegrationTest
	setup do
		@user = users :one
		@event = events :one
		
		visit root_path	
	end
	
	test 'navitem buttons' do 
		assert page.has_css? '.nav-item'
		find_link('Home', match: :first).click
		assert_equal '/', current_path
		find_link('About', match: :first).click
		assert_equal '/aboutus', current_path
		find_link('Discover Previous Conversations', match: :first).click
		assert_equal '/supportourwork', current_path 
		find_link('FAQ', match: :first).click
		assert_equal '/faq', current_path
	end
  
	test 'sign up' do
		assert page.has_css? '.navbar-btn'
		assert page.has_link? 'Sign Up'
		find_link('Sign Up', match: :first).click
		assert_equal '/signup', current_path

	end

	test 'sign in' do
		binding.pry
		assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign In'
		find_link('Sign In', match: :first).click
    assert_equal '/login', current_path
		sign_in
		assert_equal '/', current_path
	end
  
	private
  def sign_in
    visit root_path users

    click_on 'Sign In', match: :first

    fill_in id: 'user_email', with: "#{@user.email}"
    fill_in id: 'user_password', with: "#{@user.password}"

    click_on class: 'form-control btn-primary'
  end
end
