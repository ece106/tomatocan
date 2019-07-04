require 'test_helper'
require 'capybara-screenshot/minitest'

class UserVisitsEventPage < ActionDispatch::IntegrationTest

  setup do
    @user  = users(:one)
    @event = events(:one)
    @rsvpq = rsvpqs(:one)

    sign_in_as @user

    visit event_path @event
  end

  test "visits event page successfully" do
    page.status_code == 200
  end

  test "visits events page unsuccessfully" do
    page.status_code == 400
  end

  test "should see the correct event title" do
    assert page.has_content? @event.name
  end

  test "should see the correct event host" do
    assert page.has_content? @user.name
  end

  # TODO: coming back to this
  # test "should see the edit event link" do
  #   assert page.has_link?("Edit Show")
  # end

  test "should see the correct start date" do
    assert page.has_content? @event.start_at.strftime("%A, %B %d")
  end

  test "should see the correct start at timezones" do
    assert page.has_content?(@event.start_at.strftime("%I:%M %p"))
    assert page.has_content?((@event.start_at + 3.hours).strftime("%I:%M %p"))
  end

  test "can join live discussion successfully" do
    click_on "Join Live Discussion"
  end

  test "can join live show successfully" do
    click_on "Join Live Show"
  end

  test "can share event" do
    page.has_css? "#shareBtn"

    click_on id: "shareBtn"

    assert page.has_xpath? "//img[@src = 'https://static.licdn.com/sc/h/eahiplrwoq61f4uan012ia17i' and @alt='LinkedIn']"
    assert page.has_xpath? "//img[@src = 'https://www.facebook.com/images/fb_icon_325x325.png' and @alt='Facebook']"
    assert page.has_xpath? "//img[@src = 'https://about.twitter.com/etc/designs/about-twitter/public/img/apple-touch-icon-72x72.png' and @alt='Twitter']"
  end

  test "can make an rsvp for event" do
    click_on id: "RSVPsubmit"
  end

  private

  def sign_in_as user
    visit root_path
    click_on 'Sign In', match: :first
    fill_in id: 'user_email', with: user.email
    fill_in id: 'user_password', with: user.encrypted_password
    click_on class: 'form-control btn-primary'
  end

end
