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
		fill_in('Name', with: 'name')
		fill_in('Email', with: 'e@mail.com')
		fill_in('Username', with:'username')
		fill_in("Password", with: 'password', :match => :prefer_exact)
		fill_in(id:"user_password_confirmation", with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text ('Sign out')
	end
end
