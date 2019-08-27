require 'test_helper'
require 'capybara-screenshot/minitest'

class UserLandingFooter < ActionDispatch::IntegreationTest
	setup do
		@test_user = user :one

    sign_in

    visit root_path
	end
	
	test 'About link' do
		
	end
	
	test 'FAQ link' do
		
	end
	
	test 'Terms of Service link' do
		
	end
	
	test 'contact email link' do
		
	end
	
	test 'share site with others' do
		page.has_class? 'social-share-button'
		
		click_on class: 'social-share-button'
		
		facebook_img = 
		twitter_img = 
		linkedin_img = 
		email_img = 
		
		assert page.has_xpath? facebook_img
		assert page.has_xpath? twitter_img
		assert page.has_xpath? linkedin_img
		assert page.has_xpath? email_img
	end
	
	def sign_in
    visit root_path user

    click_on 'Sign In', match: :first

    fill_in id: 'user_email', with: "#{user.email}"
    fill_in id: 'user_password', with: "#{user.password}"

    click_on class: 'form-control btn-primary'
  end
end
