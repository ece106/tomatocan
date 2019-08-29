require "test_helper"
require "capybara-screenshot/minitest"

class UserLandingHeader < ActionDispatch::IntegrationTest
	setup do
		@test_user = user :one
		@event = event :one
		
		sign_in
		
		visit root_path	
	end

	test 'star icon goes to static page successfully' do
		assert page.has_id? 'navbarLogo'
		click_on id: navbarLogo
		binding.pry
		assert_equal current_path, root_path
	end

	test 'navigation buttons successful' do 
		assert page.has_class? 'nav-item'
		click_on class: 'nav-item'
		
		home_page = root_path
		about_page = find('link=About')
		dpc_page = find('link=Discover Previous Conversations')
		faq_page = find('link=FAQ')
		
		assert page.has_xpath? home_page
		assert page.has_xpath? about_page
		assert page.has_xpath? dpc_page
		assert page.has_xpath? faq_page
	end

	test "go to View Profile page successfully" do
		assert page.has_button? ('//[@class="dropdown"]')
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
		click_on class: 'btn btn-default'
		
		assert current_path, root_path
	end

	private
	
	def sign_in
		visit root_path user

		click_on 'Sign In', match: :first

		fill_in id: 'user_email', with: "#{user.email}"
		fill_in id: 'user_password', with: "#{user.password}"

		click_on class: 'form-control btn-primary'
	end
end
