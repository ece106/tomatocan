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
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Shows', match: :first)
    assert_text('Livestream Directions')
  end
  test "should be able to start your live show now" do
    #signup()
    click_on('Phineas')
    click_on('View Profile')
    click_on('Start Your Live Show Now')
    assert_text('s Live Show')
  end
  test "Join button should be visible if the user is not signed it" do
    click_on('Sign out')
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
    #signup()
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
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Shows', match: :first)
    click_on('Set Up Future Show')
    assert_text('Post a New Show Time')
  end
  test "test if the offer rewards button redirects you to the create a reward path" do
    #signup()
    click_on('Offer Rewards', match: :first)
    assert_text('Create a Reward')
  end
  test "test if user can start their live stream now from the show tab" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Shows')
    click_on('Start Your Live Show Now')
  end
  test "sales tab should say sales are coming soon if the user is not connected with stripe" do
    click_on('Sign out')
    signup()
    click_on('name')
    click_on('Control Panel')
    click_on('Sales')
    assert_text('Sales figures will be displayed on this page after you connect to Stripe.')
  end
  test "should be able to create a reward" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)
    fill_in(id: 'merchandise_name', with: 'Shoe')
    fill_in(id: 'merchandise_price', with: '5')
    fill_in(id: 'merchandise_desc', with: 'this is a description')
    click_on(class: 'btn btn-lg btn-primary')
    assert_text('Shoe')
  end
  test "should not be able to create a reward" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)
    click_on(class: 'btn btn-lg btn-primary')
    assert_text('errors prohibited this Reward from being saved:')
  end
  test "rewards should show in create a reward after creating them" do
    createReward()
    within(id: 'merchSidebar') do
      assert_text('Shoe')
    end
  end
  test "check if edit reward directs to the right place" do
    createReward()
    within(id: 'merchSidebar') do
      click_on('Edit Reward', match: :first)
    end
    assert_text('Edit Reward: Shoe')
  end
  test "check if the reward is updated after the rewards is edited and saved" do

  end
  test "check if Patron is successfully updated after editing a reward" do
    createReward()
    within(id: 'merchSidebar') do
      click_on('Edit Reward', match: :first)
    end
    click_on(class: 'btn btn-lg btn-primary')
    # assert_text('Patron Perk was successfully updated.')
  end
  test "test if expired rewards show up in the past rewards" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)
    fill_in(id: 'merchandise_name', with: 'Shoe')
    fill_in(id: 'merchandise_price', with: '5')
    fill_in(id: 'merchandise_desc', with: 'this is a description')
    #click_on('2019')
    #click_on('January')
    click_on(class: 'btn btn-lg btn-primary')
    click_on('Phineas', match: :first)
    click_on('Control Panel')
    click_on('Rewards')
    within(class: 'media-body', match: :first) do
      assert_text('Shoe')
    end
  end
  test "test if home link works while home" do
    click_on('Home')
    assert_text('Doing Purposeful Work?')
  end
  test "discover talk show hosts link should work in the navbar" do
    click_on('Discover Talk Show Hosts')
    assert_text('Discussion Hosts')
  end
  test "terms of service link works when in the signup page" do
    click_on('Sign out')
    click_on('Sign Up', match: :first)
    click_on('Terms of Service', match: :first)
    assert_text('CrowdPublish.TV Terms of Service')
  end
  test "already a member? sign in link redirects" do
    click_on('Sign out')
    click_on('Sign Up', match: :first)
    within(class: 'col-lg-6 col-lg-offset-1') do
      click_on('Sign in')
    end
    assert_text('Login')
  end
  test "Terms of service link works in the login page" do
    click_on('Sign out')
    click_on('Sign In', match: :first)
    click_on('Terms of Service', match: :first)
    assert_text('CrowdPublish.TV Terms of Service')
  end
  test "forgot password link should work in login page" do
    click_on('Sign out')
    click_on('Sign In', match: :first)
    click_on('Forgot your password?')
    assert_text("email sent from 'CrowdPublish.star'")
  end
  test "Tickets to your local event option should auto-complete fields" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)

    click_on('Tickets to your local event')
    # assert_text('Tickets to My Show')
  end
  test "Post to you fan's Facebook page option should auto-complete fields" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)
    click_on("Post to your fan's Facebook page")
    # assert_text('Facebook Timeline Post from Me')
  end
  test "@mention your fan on Twitter should auto-complete fields" do
    #signup()
    click_on('Phineas')
    click_on('Control Panel')
    click_on('Rewards')
    click_on(class: 'btn btn-lg btn-warning', match: :first)

    click_on("@mention your fan on Twitter")
    # assert_text('Facebook Timeline Post from Me')
  end
  test "sales tab should render purchased items" do
    createReward()
    visit('/')
    click_on('Sign out')
    visit('http://localhost:3000/username')
    assert_text('Shoe')
    click_on('Buy')
    fill_in(id: 'purchase_email', with: 'e@email.com')
    fill_in(id: 'card_number' , with: '4242424242424242')
    fill_in(id: 'card_year' , value: '2020')
    click_on('Purchase')
    click_on('Sign In', match: :first)
    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')
    click_on(class: 'form-control btn-primary')
    click_on('Control Panel')
    click_on('Sales')
    assert_text('Mark as Read')
  end
  test "link to reward on live show page redirects" do
  end
end

