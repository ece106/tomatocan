require "test_helper"
require "capybara-screenshot/minitest"

class UserEditsEvent < ActionDispatch::IntegrationTest
  setup do
    @user  = users :one
    @event = events :one

    sign_in

    visit edit_event_path @event
  end

  test "visits edit event page successfully" do
    page.status_code == 200
  end

  test "update event with invalid attributes" do
    fill_in id: "event_name", with: ""
    fill_in id: "event_desc", with: "http://www.thinq.tv/"

    click_on class: "update-event-btn"

    assert_equal current_path, event_path(@event)
    assert page.has_css? "#error_explanation"
  end

  test "update event with valid attributes" do
    fill_in id: "event_name", with: "Updating Event Name"
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

    click_on class: "update-event-btn"

    assert current_path, event_path(@event)

    assert page.has_content? "Updating Event Name"
    assert page.has_content? "New Event Description"
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
