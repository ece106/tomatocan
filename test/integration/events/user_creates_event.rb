require "test_helper"
require "capybara-screenshot/minitest"

class UserCreatesEvent < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :one

    sign_in

    visit new_event_path
  end

  # NOTE: Need to come back to this. Capybara can't click on button.
  # Functionality still works though.
  test "create event with invalid attributes" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: "http://www.thinq.tv/"

    click_on class: "create-event-btn"

    assert_equal current_path, new_event_path
  end

  test "user creates event with valid attributes" do
    fill_in id: "event_name", with: "New Test Event Name"
    fill_in id: "event_desc", with: "New Event Description"

    select "2019", from: "event_start_at_1i"
    select "July", from: "event_start_at_2i"
    select "16", from: "event_start_at_3i"
    select "03 PM", from: "event_start_at_4i"
    select "30", from: "event_start_at_5i"

    select "2019", from: "event_end_at_1i"
    select "July", from: "event_end_at_2i"
    select "16", from: "event_end_at_3i"
    select "04 PM", from: "event_end_at_4i"
    select "30", from: "event_end_at_5i"

    click_on id: "eventSubmit"
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
