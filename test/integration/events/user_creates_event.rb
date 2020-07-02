require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit edit_event_path @event
  end

=begin
As of 07/01/2020 all tests work

READ ME
These tests focus on creating valid and invalid events

Note: options start at 1 so for the month option[1] = January, for day option[5] = day 5, and 
so on.

Capybara doesn't automatically set hidden fields.
For tests that use hidden fields you should set them manually.

=end

time_zone_test = "-07:00"

  test "user creates event with valid attributes" do
    fill_in id:'event_name', with: 'Valid Event Name'
    fill_in id: 'event_desc', with: 'Valid Event Description'
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #option[1]= study hall, option[2]= conversation, option[3]=  User research
	
	#NOTE when new years are added and old ones deleted these tests might error or fail.
	#Date selected for test December 31, 2021 at 1:00pm
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option # selects year option[1] = 2020, option[2] = 2021.
	
	find('#event_start_at_2i').find(:xpath, 'option[12]').select_option # selects month
	find('#event_start_at_3i').find(:xpath, 'option[31]').select_option # selects day 
	find('#event_start_at_4i').find(:xpath, 'option[14]').select_option # selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option # selects minute
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

    click_on id: 'eventSubmit', match: :first

    assert_equal current_path, root_path
    assert page.has_content? "Valid Event Name"
	assert page.has_content? "userconfirmed"
  end
  
  test "create event with empty string name" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: ""
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	#Date selected for test July 1, 2021 12:00am Thursday
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option#Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option#select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option#selects day
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option#selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option#selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

	click_on id: 'eventSubmit', match: :first
	
	#Since there are empty strings through out the page it is better to see if there is a date with this associated with the event that was attempted to be created.
	assert_not page.has_content? "Thu, July 1"
	
  end

  test "create event with spaces for name" do
    fill_in id: "event_name", with: "   "
    fill_in id: "event_desc", with: "Blank spaces"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	#Date selected for test July 3, 2021 12:00am Saturday
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

	click_on id: 'eventSubmit', match: :first
	
	#Since there are empty strings through out the page it is better to see if there is a date with this associated with the event that was attempted to be created.
	assert_not page.has_content? "Sat, July 3"
	
  end

  test "create event with URL desc" do
    fill_in id: "event_name", with: "Not Valid Desc"
    fill_in id: "event_desc", with: "thinq.tv"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	#Date selected for test July 3, 2021 1:00am Saturday
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[2]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

    click_on class: "btn btn-lg btn-primary", match: :first

	assert_not page.has_content? "Not Valid Desc"
	
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
