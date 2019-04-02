require 'test_helper'
require 'capybara-screenshot/minitest'
class EventsTest < ActionDispatch::IntegrationTest
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    Capybara::Screenshot.autosave_on_failure = false# disable screenshot on failure
    setup do
    visit ('/')#user is at the home page by default
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
def createEvent()
    signup()
    click_on('Host Discussion')
    fill_in(id:'event_name', with: 'Intern')
    fill_in(id:'event_desc', with: 'This is a description of the event')
    click_button(class: 'btn btn-lg btn-primary')
    assert_text('Intern')#does the event show up on the homepage?
end
test "Should login before hosting a discussion" do
    click_on('Host Discussion')
    assert_text ('Login')
end
test "Should sign up and then host a discussion and get redirected to new event page" do
    signup()
    click_on('Host Discussion')
    fill_in(id:'event_name', with: 'Intern')
    fill_in(id:'event_desc', with: 'This is a description of the event')
    click_button(id: 'eventSubmit')
    assert_text('Intern')#does the event show up on the homepage?
    #click_on('Sign out')
    #click_on('Join Discussion')
    #assert_text('Live Show')
end
test "Should not save event if title of livestream show is not given" do
    signup()
    click_on('Host Discussion')
    click_on(class: 'btn btn-lg btn-primary')#button seems to not be visible on the page needs solution
    assert_text('1 error prohibited this event from being saved:')
end
test "Should redirect after host a livestream discussion is clicked" do
    signup()
    click_on(class: 'btn btn-warning')
    assert_text('*Title of Livestream Show')
end
test "Should be able to join a livestream discussion when signed out" do
    # click_on(class: 'btn btn-primary btn-sm')#Click Signup
    # assert_text('s Live Show')
end
test "Should show live stream instructions in the Streaming tab in Control Panel " do
    signup()
    click_on('name')
    click_on('Control Panel')
    click_on('Shows', match: :first)
    assert_text('Livestream Directions')
end
test "should be able to start your live show now" do
    signup()
    click_on('name')
    click_on('View Profile')
    click_on('Start Your Live Show Now')
    assert_text('s Live Show')
end
test "Join button should be visible if the user is not signed it" do
    assert_text('Join')
    
end
test "Test if the FAQ links work and redirect to the correct place" do
    within(class: 'collapse navbar-collapse') do
        click_on('FAQ')
    end
    assert_text('t accessing my mic or webcam')
end
test "test if the home link works" do
    click_on('FAQ', match: :first)
    click_on('Home')
    assert_text('Doing Purposeful Work?');
end
test "test if the offer rewards button works" do
    signup()
    click_on('Offer Rewards')
    assert_text('Create a Reward')
end
test "test if second FAQ link works" do
    within(id:'faqBlock') do #click the link within the div class
        click_on('FAQ')
    end
    assert_text('t accessing my mic or webcam')
end
test "Test if bottom FAQ link works on homepage" do
    within(class: "col-sm-2 col-sm-offset-1") do #click the link within the div class
        click_on('FAQ')
    end
    assert_text('t accessing my mic or webcam')
end
test "Test if the About link at the bottom of the home page redirects properly" do
    click_on('About')
    assert_text('What is CrowdPublish.TV?')
end
test "terms of service link should redirect to the right page" do
    click_on('Terms of Service')
    assert_text('CrowdPublish.TV Terms of Service')
end
test "Test if set up future show button works in the Shows tab" do
    signup()
    click_on('name')
    click_on('Control Panel')
    click_on('Shows', match: :first)
    click_on('Set Up Future Show')
    assert_text('Post a New Show Time')
    
end
test "test if the offer rewards button redirects you to the create a reward path" do
    signup()
    click_on('Offer Rewards', match: :first)
    assert_text('Create a Reward')
end
test "test if user can start their live stream now from the show tab" do
    signup()
    click_on('name')
    click_on('Control Panel')
    click_on('Shows')
    click_on('Start Your Live Show Now')
end
test "sales tab should say sales are coming soon if the user is not connected with stripe" do
    signup()
    click_on('name')
    click_on('Control Panel')
    click_on('Sales')
    assert_text('Sales figures will be displayed on this page after you connect to Stripe.')
end
test "check is save changes on user's view profile redirects " do
    
end
end


