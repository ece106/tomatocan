require "test_helper"
require "capybara-screenshot/minitest"

class UserLandingHeader < ActionDispatch::IntegrationTest
	setup do
		@test_user = user :one
		
		sign_in
		
		visit root_path	
	end

	test 'star icon goes to static page successfully' do
		assert page.has_id? 'navbarLogo'
		click_on id: navbarLogo
		binding.pry
		assert_equal current_path, root_path
	end

	test 'home button visits static page successfully' do 
		assert page.has_button? 'Home'
		click_on 'Home'

		assert_equal current_path, root_path
	end

	test 'about button goes to about page successfully' do
		assert page.has_button? 'About'
		click_on 'About'
		
		about_page = find()
		
		assert_equal current_path, about_page
	end

	test "go to Discover Previous Conversations successfully" do
		assert page.has_button? 'Discover Previous Conversations'
		click_on 'Discover Previous Conversations'
		
		discover_prev_page = find()
		
		assert_equal current_path, discover_prev_page
	end

	test "go to FAQ page successfully" do
		assert page.has_button? 'FAQ'
		click_on 'FAQ'
		
		faq_page = find()
		
		assert_equal current_path, faq_page
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
