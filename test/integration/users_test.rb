require 'test_helper'
#require 'capybara'
class UsersTest < ActionDispatch::IntegrationTest
 
  # test "the truth" do
  #   assert true
  # end
  	setup do
  		visit ('http://localhost:3000/')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_permalink', with:'username')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		click_on('Sign out')

		def signInUser()
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
		click_on('Sign In', match: :first)
		fill_in(id:'user_email', with: 'e@gmail.com')
		fill_in(id:'user_password', with: 'password')
		click_on(class: 'form-control btn-primary')
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		assert_text('Rewards')
	end 

	test "Should_change_password" do
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
		signInUser()
		click_on(class: 'dropdown-toggle')
		click_on('Control Panel')
		click_on('Account')
		fill_in(id:'user_email', with: 'e2@mail.com')
		click_on(id:'saveProfileButton',:match => :first)
		assert_text('Videos')

	end

	test "Should_show_video" do
		signInUser()
		click_on('Discover Talk Show Hosts')
		assert_text('Phineas')

	end

	test "Should_not_show_other_controlpanel" do
		visit('http://localhost:3000/username/controlpanel')
		refute_text('Edit Profile')
	end
	
	#test number of panels

		
end
