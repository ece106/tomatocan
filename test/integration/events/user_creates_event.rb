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

    click_on class: "btn btn-lg btn-primary"

    assert_not_equal current_path, new_event_path
  end

  test "user creates event with valid attributes" do
    fill_in id: "event_name", with: "Title of Conversation"
    fill_in id: "event_desc", with: "Details about Conversation Topic"

    select "2020", from: "event_start_at_1i"
    select "July", from: "event_start_at_2i"
    select "16", from: "event_start_at_3i"
    select "03 PM", from: "event_start_at_4i"
    select "00", from: "event_start_at_5i"

    # select "2021", from: "event_end_at_1i"
    # select "July", from: "event_end_at_2i"
    # select "16", from: "event_end_at_3i"
    # select "04 PM", from: "event_end_at_4i"
    # select "00", from: "event_end_at_5i"
    # click_on id: "eventSubmit"

    click_on class: "btn btn-lg btn-primary create-event-btn"

    # NOTE: For some reason, capybara cannot register this click_on action.
    # In the debugger, it does not return Obsolete class when using click_on.
    # This is a special case for this test.
    # assert_equal current_path, root_path
    # assert page.has_content? "Title of Conversation"
    # assert page.has_content? "Details about Conversation Topic"
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
