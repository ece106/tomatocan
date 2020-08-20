require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserRsvpq < ActionDispatch::IntegrationTest
  setup do
    @user1  = users :one
    @user  = users :confirmedUser
    @event = events :confirmedUser_event

    user_sign_in @user1
  end

  test 'user rsvpq for events' do
    visit '/userconfirmed'
    click_on id: 'calendar-event', match: :first

    click_on id: 'RSVPsubmit', match: :first

    #name displayed in dropdown list
    click_on class: 'btn btn-primary dropdown-toggle', match: :first
    assert page.has_content? "userconfirmed"

    #no RSVP button anymore
    assert_not page.has_content? "RSVP NOW"

    #check if rsvpd events show in profile page or not
    visit '/user1'
    click_on id: 'calendar-event', match: :first
    assert page.has_content? "Hosted by userconfirmed"
  end
  
end
