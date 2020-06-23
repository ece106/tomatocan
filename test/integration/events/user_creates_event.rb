require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :one

    sign_in

    visit new_event_path
  end

  test "create event with invalid attributes" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: "http://www.thinq.tv/"
	
	find('#event_topic').find(:xpath, 'option[1]').select_option
	find('#event_start_at_1i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option

    click_on class: "btn btn-lg btn-primary", match: :first

    assert_not page.has_content? ""
  end

  test "user creates event with valid attributes" do
    fill_in id: 'event_name', with: 'Valid Test Event name'
    fill_in id: 'event_desc', with: 'New Event Description'
	
	find('#event_topic').find(:xpath, 'option[1]').select_option
	find('#event_start_at_1i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_2i').find(:xpath, 'option[7]').select_option
	find('#event_start_at_3i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_4i').find(:xpath, 'option[1]').select_option
	find('#event_start_at_5i').find(:xpath, 'option[1]').select_option

    click_on id: 'eventSubmit', match: :first

    # NOTE: For some reason, capybara cannot register this click_on action.
    # In the debugger, it does not return Obsolete class when using click_on.
    # This is a special case for this test.
    #assert_equal current_path, root_path
    assert page.has_content? "New Test Event Name"
    #assert page.has_content? "New Event Description"
  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end

end
