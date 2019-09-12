require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserNavbar < ActionDispatch::IntegrationTest
	setup do
		@user = users :one
		@event = events :one
		
		sign_in @user
		
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
	
	test 'view profile page' do
		assert text, "#{@user.name}"
		assert page.has_css? '.dropdown'
		assert page.has_css? '.dropdown-toggle'
		find(class: 'dropdown-toggle',match: :first).click

		assert page.has_link? 'View Profile'
		find_link('View Profile',match: :first).click
		assert_equal "/#{@user.permalink}", current_path
	end
	
	test 'view control panel page' do
		assert text, "#{@user.name}"
		assert page.has_css? '.dropdown'
		assert page.has_css? '.dropdown-toggle'
		find(class: 'dropdown-toggle',match: :first).click

    assert page.has_link? 'Control Panel'
		find_link('Control Panel',match: :first).click
		#ask about the user.permalink thing not working below
		assert_equal "/#{@user.permalink}/controlpanel", current_path
	end
		
	test 'logout successfully' do
		#assert page.has_css? 'btn btn-default'
		click_on class: 'btn btn-default', match: :first
		
		assert '/', current_path
	end

	private
	
	def sign_in users
		visit root_path

		click_on class: 'btn btn-default'

		fill_in id: 'user_email', with: "#{users.email}"
		fill_in id: 'user_password', with: "user1234"

		click_on class: 'form-control btn-primary'
	end
	
	def teardown
	end
end
