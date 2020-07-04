require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsEvent < ActionDispatch::IntegrationTest
  setup do
    @user  = users :confirmedUser
    @event = events :one

    user_sign_in @user

    visit "/events/6/edit"
  end

=begin
As of 07/03/2020 all tests work

READ ME
These tests focus on editing events to valid and invalid attributes

Note: options start at 1 so for the month option[1] = January, for day option[5] = day 5, and 
so on.

Capybara doesn't automatically set hidden fields.
For tests that use hidden fields you should set them manually.

=end

  test "visits edit event page successfully" do
    page.status_code == 200
  end
  
  test "succesful edit" do
  
	fill_in id: 'event_name', with: 'edited event'
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set "-07:00" #sets the timezone manually
	
	click_on class: "btn btn-lg btn-primary update-event-btn", match: :first
	
	assert page.has_content? "edited event"
	assert page.has_content? "December 11"
  
  end

  test "Update with invalid name" do
	fill_in id: 'event_name', with: ''
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set "-07:00" #sets the timezone manually

    click_on class: "btn btn-lg btn-primary update-event-btn", match: :first
	
    assert page.has_css? "#error_explanation"
	assert page.has_content? "Name can't be blank"
	
  end

  test "Update with invalid desc" do
	
	fill_in id: "event_desc", with: "thinq.tv"
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set "-07:00" #sets the timezone manually

    click_on class: "btn btn-lg btn-primary update-event-btn", match: :first
	
    assert page.has_css? "#error_explanation"
	assert page.has_content? "Desc descriptions ...URLs are not allowed in event descriptions. Keep in mind that people will be searching here for actual gatherings that they can attend, or to find out when you'll be livestreaming. They will not be searching for sites to browse. Paste all information attendees need here."
  end

  test "Update time" do
	
	#NOTE when the following date pases this test will become useless
	#Date selected for test December 31, 2020 at 2:00PM
	find('#event_start_at_1i').find(:xpath, 'option[1]').select_option # selects year option[1] = 2020, option[2] = 2021.
	find('#event_start_at_2i').find(:xpath, 'option[12]').select_option # selects month
	find('#event_start_at_3i').find(:xpath, 'option[31]').select_option # selects day 
	find('#event_start_at_4i').find(:xpath, 'option[11]').select_option # selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option # selects minute
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set "-07:00" #sets the timezone manually

    click_on class: "btn btn-lg btn-primary update-event-btn", match: :first
	
	assert page.has_content? "confirmedUser_event"
	assert page.has_content? "December 31"
	assert page.has_content? "2:00 PM"
	

  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'thinqtesting@gmail.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
