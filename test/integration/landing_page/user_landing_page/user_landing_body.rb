require 'test_helper'
require 'capybara-screenshot/minitest'

class UserLandingBody < ActionDispatch::IntegrationTest
	setup do
		@user = users :one
		@event = events :one
		
    sign_in
		
    visit root_path
	end
		
	test 'tech tuesday links' do
		assert page.has_link? 'Tech Tuesday'
		click_link 'Tech Tuesday'
		
		tech_page = find('Tech Tuesday')
		
		assert_equal current_path, tech_page
	end
	
	test 'conversations on faith link' do
		assert page.has_link? 'Conversations on Faith'
		click_link 'Conversations on Faith'
		
		faith_page = find('Conversations on Faith')
		
		assert_equal current_path, faith_page
	end

	test 'international awareness link'do
		assert page.has_link? 'International Awareness'
		click_link 'Internatoinal Awareness'
		
		international_page = find('International Awareness')
		
		assert_equal current_path, international_page
	end
	
	test 'Join Conversation successfully' do
		assert page.has_button? 'Join Conversation'
		click_button 'Join Conversation'
		
		converse_page = find('Join Conversation')
		
		assert_equal current_path, converse_page
	end
	
	test 'Countdown Clock Runs Successfully' do
		assert page.has_xpath? 'layouts/countdown_clock'
			
	end
	
	test 'Link to Upcoming Conversation' do
		skip
	end
	
	test 'Link to Upcoming Conversation Host' do
		skip
	end

	test 'calender render succesful' do
		assert page.has_xpath? 'layout/maincalender'
	end
	
	test 'hosting a converstion successfully' do
		skip
	end
	
	test 'adding a new conversation successfully' do
		assert page.has_button? 'Add your Conversation'
		click_button 'Add your Conversation'
		
		add_converse_page = find('Add your Conversation')
		
		assert_equal current_path, add_converse_page
	end
	
	def sign_in
    visit root_path users

    click_on 'Sign In', match: :first

    fill_in id: 'user_email', with: "#{@user.email}"
    fill_in id: 'user_password', with: "#{@user.password}"

    click_on class: 'form-control btn-primary'
  end
end

