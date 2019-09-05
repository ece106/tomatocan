require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserLandingHeader < ActionDispatch::IntegrationTest
	setup do
		@user = users :one
		@event = events :one
		
		sign_in
		
		visit root_path	
	end

	test 'logo link' do
		skip
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
	
	test "go to View Profile page successfully" do
		assert page.has_css? '.dropdown'
		assert page.has_css? '.dropdown-toggle'
		drop_down = find_element(class: 'dropdown')
		click_on class: 'dropdown'
		assert dropdown.has_button? 'Profile'
		click_on 'Profile'
		
		assert_equal current_path, "/#{@user.permalink}"
	end
	
	test "go to Control Panel page" do
		assert page.has_button? ('//[@class="dropdown"]')
    drop_down = find_element(class: 'dropdown')
    click_on class: 'dropdown'
    assert dropdown.has_button? 'Control Panel'
    click_on 'Control Panel'

		assert_equal current_path, "/#{@user.permalink}"
	end
		
	test 'logout successfully' do
		assert page.has_css? ('btn btn-default')
		click_on class: 'btn btn-default'
		
		assert current_path, root_path
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
