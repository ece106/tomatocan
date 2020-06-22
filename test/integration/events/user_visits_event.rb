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

    new_linkedin_sharewindow = window_opened_by { click_link linkedin_img }
    within_window new_linkedin_sharewindow do
      assert page.has_content?
    end

    new_facebook_sharewindow = window_opened_by { click_link facebook_img }
    within_window new_facebook_sharewindow do
      assert page.has_content?
    end

    new_twitter_sharewindow = window_opened_by { click_link twitter_img }
    within_window new_twitter_sharewindow do
      assert page.has_content?
    end
  	
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

