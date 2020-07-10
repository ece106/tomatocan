require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesRecurringEvent < ActionDispatch::IntegrationTest

  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit new_event_path
  end

time_zone_test = "-07:00"

  test "user creates recurring event" do
  	test_event = Event.new(name: "Valid Event Name",desc: "desc", start_at: "2020-12-11 11:00:00", end_at: "2020-12-11 11:00:00", recurring: '{:validations=>{}, :rule_type=>"IceCube::DailyRule", :interval=>1}' )
	refute test_event.valid?
	visit root_path
  	
    fill_in id:'event_name', with: 'Valid Event Name'
    fill_in id: 'event_desc', with: 'Valid Event Description'
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #topic
	
	#NOTE when new years are added and old ones deleted these tests might error or fail.
	#Date selected for test July 2, 2020
	find('#event_start_at_1i').find(:xpath, 'option[1]').select_option # Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option # selects month
	find('#event_start_at_3i').find(:xpath, 'option[13]').select_option # selects day 
	find('#event_start_at_4i').find(:xpath, 'option[14]').select_option # selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option # selects minute
	
	find(:xpath, "//*[@id='timeZone']", visible: false).set time_zone_test #sets the timezone manually

	find('#event_recurring').find(:xpath, 'option[2]').select_option
	find('#rs_frequency').find(:xpath, 'option[1]').select_option
	fill_in id:'rs_daily_interval', with: '1'
	click_on id: 'rs_save', match: :first

    click_on id: 'eventSubmit', match: :first
	
	#"calendar-time-day2"
    assert page.has_content? "Valid Event Name"
	assert page.has_content? "userconfirmed"
	assert_selector '#convocalendar-time-day1', text: "Thu, 13 July"
	assert_selector '#convocalendar-time-day2', text: "Thu, 14 July"
	
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