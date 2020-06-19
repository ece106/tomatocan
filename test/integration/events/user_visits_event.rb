require 'test_helper'
require 'capybara-screenshot/minitest'
require 'selenium-webdriver'

class UserVisitsEvent < ActionDispatch::IntegrationTest

  setup do
    @user  = users :one
    @event = events :one
    @rsvpq = rsvpqs :one

    sign_in

    visit event_path @event
  end

  test "visits event page successfully" do
    page.status_code == 200
  end

  test "visits event page unsuccessfully" do
    page.status_code == 400
  end

  test "should see the correct event title" do
    assert page.has_content? @event.name
  end

  test "should see the correct event host" do
    assert page.has_content? @user.name
  end

  test "should see the correct start date" do
    assert page.has_content? @event.start_at.strftime("%A, %B %d")
  end

  test "should see the correct start at timezones" do
    assert page.has_content?(@event.start_at.strftime("%I:%M %p"))
    assert page.has_content?((@event.start_at + 3.hours).strftime("%I:%M %p"))
  end

  test "can join live discussion successfully" do
    click_on "Join Conversation"

    assert_equal current_path, "/#{@user.permalink}"
  end

  test "can share event and pop up window" do

    linkedin_img = "//img[@src = 'social-share-button/linkedin.png' and @alt='LinkedIn']"
    facebook_img = "//img[@src = 'social-share-button/facebook.png' and @alt='Facebook']"
    twitter_img = "//img[@src = 'social-share-button/twitter.png' and @alt='Twitter']"

    click_button linkedin_img
    assert page.driver.browser.switch_to.alert.accept
    click_button facebook_img
    assert page.driver.browser.switch_to.alert.accept
    click_button twitter_img
    assert page.driver.browser.switch_to.alert.accept
  	
  end

  test "can make an rsvp for event" do
    click_on id: "RSVPsubmit"
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

