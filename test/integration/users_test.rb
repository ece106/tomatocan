require 'test_helper'
#require 'capybara'
class UsersTest < ActionDispatch::IntegrationTest
 
  # test "the truth" do
  #   assert true
  # end
  	setup do
  		visit ('http://localhost:3000/')
  		def signUpUser()
			visit ('http://localhost:3000/')
			click_on('Sign Up', match: :first)
			fill_in(id:'user_name', with: 'name')
			fill_in(id:'user_email', with: 'e@gmail.com')
			fill_in(id:'user_permalink', with:'username')
			fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
			fill_in(id:'user_password_confirmation', with:'password')
			click_on(class: 'form-control btn-primary')
			click_on('Sign out')
		end
		def signInUser()
			visit ('http://localhost:3000/')
			click_on('Sign In', match: :first)
			fill_in(id:'user_email', with: 'e@gmail.com')
			fill_in(id:'user_password', with: 'password')
			click_on(class: 'form-control btn-primary')
		end
  	end
	test "Should_view_profileinfo" do
		visit ('http://localhost:3000/')
		click_on('Discover Talk Show Hosts')
		assert_text ('Discussion Hosts')
	end
	test "Should_sign_up" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name2')
		fill_in(id:'user_email', with: 'e2@gmail.com')
		fill_in(id:'user_permalink', with:'username2')
		fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password2')
		click_on(class: 'form-control btn-primary')
		assert_text ('Sign out') 
	end
	test "Should_sign_up_and_then_out" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name2')
		fill_in(id:'user_email', with: 'e2@gmail.com')
		fill_in(id:'user_permalink', with:'username2')
		fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password2')
		click_on(class: 'form-control btn-primary')
		click_on('Sign out')
		assert_text('Sign Up')
	end
	test "Should_sign_up_and_then_out_and_then_back_in" do
		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name2')
		fill_in(id:'user_email', with: 'e2@gmail.com')
		fill_in(id:'user_permalink', with:'username2')
		fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password2')
		click_on(class: 'form-control btn-primary')
		click_on('Sign out')
		click_on('Sign In')
		fill_in(id:'user_email', with: 'e2@gmail.com')
		fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
		click_on(class: 'form-control btn-primary')
		assert_text ('Sign out') 
		
	end
	#todo: write a test that fails to sign up
	test "Should_see_rewards_in_control_panel" do
		visit ('http://localhost:3000/')
		signUpUser()
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		assert_text('Rewards')
	end 
	test "Should_change_password" do
		signUpUser()
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		click_on('Account')
		click_on('Change Password')
		fill_in(id:'user_password_confirmation',with: 'password1', :match => :prefer_exact)
		fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
		click_on("Save Profile")
		click_on('Sign out')
		click_on('Sign In', match: :first)
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_password', with: 'password1')
		click_on(class: 'form-control btn-primary')
		assert_text('CrowdPublish.TV is for nonprofits,')
	end
	test "Should_change_email" do
		signUpUser()
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		click_on('Account')
		fill_in(id:'user_email', with: 'e2@mail.com')
		click_on(id:'saveProfileButton',:match => :first)
		assert_text('Videos')

	end
	test "Should_not_change_email"do
		signUpUser()
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		click_on('Account')
		fill_in(id:'user_email', with: 'e2')
		click_on(id:'saveProfileButton',:match => :first)
		refute_title('Videos')
	end
	test "Should_show_video" do
		click_on('Discover Talk Show Hosts')
		assert_text('Phineas')

	end
	test "Should_not_show_video" do
		click_on('Discover Talk Show Hosts')
		refute_title('name2')

	end
	test "Should_not_show_other_controlpanel" do
		visit('http://localhost:3000/user1/controlpanel')
		refute_title('Edit Profile')
	end
	test 'Should_fail_change_password' do
		signUpUser()
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		click_on('Account')
		click_on('Change Password')
		fill_in(id:'user_password_confirmation',with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
		click_on("Save Profile")
		assert_text('Passwords do not match')
	end
	test 'Should_show_FAQs' do
		visit('http://localhost:3000/')
		click_on('FAQ', :match => :first)
		assert_text('What are the steps for Discussion Hosts to host a show on CrowdPublish.TV?')
	end
	#These tests are in progress
	test 'Should_see_donate' do
		visit('http://localhost:3000/')
		click_on('Discover Talk Show Hosts')
		click_link('Phineas')
		assert_text('Donate $25.00!')
	end
	test 'Should_donate_25' do
		visit('http://localhost:3000/')
		click_on('Discover Talk Show Hosts')
		click_link('Phineas')
		click_on('Donate $25.00!')
		fill_in(id:'card_number', with:'4242424242424242')
	end
	#test number of panels

		
end