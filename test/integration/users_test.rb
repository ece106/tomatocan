require 'test_helper'
#require 'capybara'
class UsersTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
	test "Should view profileinfo" do
		visit ('http://localhost:3000/')
		click_on('Discover Talk Show Hosts')
		assert_text ('Discussion Hosts')
	end
	test "Should sign up" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text ('Sign out') 
	end
	test "Should sign up and then out" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		click_on('Sign out')
		assert_text('Sign Up')
	end
	test "Should sign up and then out and then back in" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		click_on('Sign out')
		click_on('Sign In')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		click_on(class: 'form-control btn-primary')
		assert_text ('Sign out') 
		
	end
	#todo: write a test that fails to sign up
	test "Should see rewards in control panel" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		assert_text('Rewards')
	end 

	
	#test number of panels

		
end
