require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class NonuserRsvpq < ActionDispatch::IntegrationTest
  setup do
    @confirmedUser = users :confirmedUser
    @event = events :confirmedUser_event
  end

  test 'nonuser rsvpq for events' do
    visit '/userconfirmed'
    click_on id: 'calendar-event', match: :first

    #enter invalid email
    fill_in id: 'rsvpq_email', with: "abc"
    click_on id: 'RSVPsubmit', match: :first

    assert page.has_content? "Please enter a valid email address"

    #enter valid email
    fill_in id: 'rsvpq_email', with: "abctest@gmail.com"
    click_on id: 'RSVPsubmit', match: :first
    #name displayed in dropdown list
    click_on class: 'btn btn-primary dropdown-toggle', match: :first
    assert page.has_content? "abctest"

  end
  
end
