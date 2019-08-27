require 'test_helper'
require 'capybara-screenshot/minitst'

class UserLandingBody < ActionDispatch::IntegreationTest
	setup do
		@test_user = user :one

    sign_in

    visit root_path
	end
		
	test 'tech tuesday link' do
		assert page.has_link? 'Tech Tuesday'
		click_link 'Tech Tuesday'
	end
	
	test 'conversations on faith link' do
		assert page.has_link? 'Conversations on Faith'
		click_link 'Conversations on Faith'
	end

	test 'International Awareness link'do
		assert page.has_link? 'International Awareness'
		click_link 'Internatoinal Awareness'
	end
	
	test 'Join Conversation successfully' do
		assert page.has_button? 'Join Conversation'
		click_button 'Join Conversation'
	end
	
	test 'Countdown Clock Runs Successfully' do
		skip	
	end
	
	test 'Link to Upcoming Conversation' do
		skip
	end
	
	test 'Link to Upcoming Conversation Host' do
		skip
	end

	test 'calender render succesful' do
		skip
	end
	
	test 'hosting a converstion successfully' do
		skip
	end
	
	test 'adding a new conversation successfully' do
		assert page.has_button? 'Add your Conversation'
		click_button 'Add your Conversation'
	end
	
	def sign_in
    visit root_path user

    click_on 'Sign In', match: :first

    fill_in id: 'user_email', with: "#{user.email}"
    fill_in id: 'user_password', with: "#{user.password}"

    click_on class: 'form-control btn-primary'
  end
end

