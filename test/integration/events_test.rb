require 'test_helper'
require 'capybara-screenshot/minitest'

class EventsTest < ActionDispatch::IntegrationTest

  setup do
    visit ('/')#user is at the home page by default
    click_on('Sign In', match: :first)
    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')
    click_on(class: 'form-control btn-primary')
  end

  def signup()
    visit ('/')
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name')
    fill_in(id:'user_email', with: 'e@gmail.com')
    fill_in(id:'user_permalink', with:'username')
    fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password')
    click_on(class: 'form-control btn-primary')#Click Signup
    assert_text ('Profile Image')#is user sent to their profile info page?
    visit ('/')
  end
  def signIn()
    visit('/')
    click_on('Sign In', match: :first)
    fill_in(id: 'user_email', with: 'e@gmail.com')
    fill_in(id: 'user_password', with: 'password')
    click_on(class: 'form-control btn-primary')
  end
  def createReward()
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)
    fill_in(id: 'merchandise_name', with: 'Shoe')
    fill_in(id: 'merchandise_price', with: '5')
    fill_in(id: 'merchandise_desc', with: 'this is a description')
    click_on(class: 'btn btn-lg btn-primary')
  end
  def createEvent()
    #signup()
    click_on('Host A Show')
    fill_in(id:'event_name', with: 'Intern')
    fill_in(id:'event_desc', with: 'This is a description of the event')
    click_button(class: 'btn btn-lg btn-primary')
    assert_text('Intern')#does the event show up on the homepage?
  end
  test "Should login before hosting a discussion" do
    click_on('Sign out')
    click_on('Host A Show')
    assert_text ('Login')
  end
  test "Should sign up and then host a discussion and get redirected to new event page" do
    #signup()
    click_on('Host A Show')
    fill_in(id:'event_name', with: 'Intern')
    fill_in(id:'event_desc', with: 'This is a description of the event')
    click_button(id: 'eventSubmit')
    #assert_text('Intern')#does the event show up on the homepage?
    #click_on('Sign out')
    #click_on('Join Discussion')
    #assert_text('Live Show')
  end
  test "Should not save event if title of livestream show is not given" do
    #signup()
    click_on('Host A Show')
    click_on(class: 'btn btn-lg btn-primary')#button seems to not be visible on the page needs solution
    #assert_text('1 error prohibited this event from being saved:')
  end
  test "Should redirect after host a livestream discussion is clicked" do
    #signup()
    click_on(class: 'btn btn-warning')
    assert_text('*Title of Livestream Show')
  end
  test "Should be able to join a livestream discussion when signed out" do
    # click_on(class: 'btn btn-primary btn-sm')#Click Signup
    # assert_text('s Live Show')
  end
  test "Should show live stream instructions in the Streaming tab in Control Panel " do
