require 'test_helper'
#require 'capybara'
class UsersTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
	test "Should view profileinfo" do
		visit ('http://localhost:3000/')
		click_on('Discover Discussion Hosts')
		assert_text ('Discussion Hosts')
	end
	test "Should click sign up" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		puts(page.all('input',visible: :all)) 
		fill_in(:user_name, with: 'name')
		fill_in(id:'user_email', with: 'e@mail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:"user_password", with: 'password', :match => :prefer_exact)
		fill_in(id:"user_password_confirmation", with:'password')
		find_button(class: 'form-control btn-primary')
		save_and_open_page
		assert_text ('Sign out')

	end
	
end
