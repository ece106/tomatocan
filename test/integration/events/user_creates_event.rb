require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit new_event_path
  end

#No funciona me sale ArgumentError: "+HH:MM", "-HH:MM", "UTC" or "A".."I","K".."Z" expected for utc_offset
#El problema es con el timezone poner .to_i lo resuelve pero causa errores en local host

  test "user creates event with valid attributes" do
    fill_in id:'event_name', with: 'Valid Event Name'
    fill_in id: 'event_desc', with: 'Valid Event Description'
	
	
	#Note: options start at 1 so for the month option[1] = January, for day option[5] = day 5, and so on.
	find('#event_topic').find(:xpath, 'option[2]').select_option #option[1]= study hall, option[2]= conversation, option[3]=  User research
	
	#NOTE when new years are added and old ones deleted these tests might error or fail.
	#Date selected for test December 31, 2021 at 1:00pm
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option # selects year option[1] = 2020, option[2] = 2021.
	
	find('#event_start_at_2i').find(:xpath, 'option[12]').select_option # selects month
	find('#event_start_at_3i').find(:xpath, 'option[31]').select_option # selects day 
	find('#event_start_at_4i').find(:xpath, 'option[14]').select_option # selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option # selects minute

    click_on id: 'eventSubmit', match: :first

	print"\nEn el test valid attr (#{@event.name})\n\n"

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

	click_on id: 'eventSubmit', match: :first
	
	#Since there are empty strings through out the page it is better to see if there is a date with this associated with the event that was attempted to be created.
	assert_not page.has_content? "Thu, July 1"
	
  end

  test "create event with spaces for name" do
    fill_in id: "event_name", with: "   "
    fill_in id: "event_desc", with: "Blank spaces"
	
	#print"\nBlank spaces running 1 \n"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	#Date selected for test July 3, 2021 12:00am Saturday
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

	click_on id: 'eventSubmit', match: :first
	
	#Since there are empty strings through out the page it is better to see if there is a date with this associated with the event that was attempted to be created.
	assert_not page.has_content? "Sat, July 3"
	
	#print"\nblank spaces running 2\n"
	
  end

  test "create event with URL desc" do
    fill_in id: "event_name", with: "Not Valid Desc"
    fill_in id: "event_desc", with: "youtube.com"
	
	find('#event_topic').find(:xpath, 'option[2]').select_option #selects topic
	#Date selected for test July 3, 2021 1:00am Saturday
	find('#event_start_at_1i').find(:xpath, 'option[2]').select_option #Selects year
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option #select month
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option #selects day
	find('#event_start_at_4i').find(:xpath, 'option[2]').select_option #selects hour
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option #selects minute

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
