require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit new_event_path
  end

=begin
As of 07/03/2020 all tests work

READ ME
These tests focus on creating valid and invalid events

Capybara doesn't automatically set hidden fields.
For tests that use hidden fields you should set them manually.

=end

time_zone_test = "-07:00"

  test "user creates event with valid attributes" do
    fill_in id:'event_name', with: 'Valid Event Name'
    fill_in id: 'event_desc', with: 'Valid Event Description'
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #topic
	
	#NOTE when new years are added and old ones deleted these tests might error or fail.
	#Date selected for test July 2, 2020
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option # Selects year
	find('#event_start_at_2i').find(:xpath, 'option[12]').select_option # selects month
	find('#event_start_at_3i').find(:xpath, 'option[31]').select_option # selects day 
	find('#event_start_at_4i').find(:xpath, 'option[14]').select_option # selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option # selects minute
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

    click_on id: 'eventSubmit', match: :first
	
	#"calendar-time-day2"
    assert_equal current_path, root_path
    assert page.has_content? "Valid Event Name"
	assert page.has_content? "userconfirmed"
	assert page.has_content? "July 2"
	
  end
  
  test "create event with empty string name" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: ""
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option#Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option#select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option#selects day
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option#selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option#selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

	click_on id: 'eventSubmit', match: :first
	
	assert page.has_css? "#error_explanation"
	assert page.has_content? "Name can't be blank"
	
  end

  test "create event with spaces for name" do
    fill_in id: "event_name", with: "   "
    fill_in id: "event_desc", with: "Blank spaces"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

	click_on id: 'eventSubmit', match: :first
	
	assert page.has_css? "#error_explanation"
	assert page.has_content? "Name can't be blank"
	
  end

  test "create event with invalid URL desc" do
    fill_in id: "event_name", with: "Not Valid Desc"
    fill_in id: "event_desc", with: "thinq.tv"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[2]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

    click_on class: "btn btn-lg btn-primary", match: :first

	assert page.has_css? "#error_explanation"
	assert page.has_content? "Desc descriptions ...URLs are not allowed in event descriptions. Keep in mind that people will be searching here for actual gatherings that they can attend, or to find out when you'll be livestreaming. They will not be searching for sites to browse. Paste all information attendees need here."
	
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
