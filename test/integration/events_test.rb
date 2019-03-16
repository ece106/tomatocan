require 'test_helper'
require 'capybara-screenshot/minitest'
class EventsTest < ActionDispatch::IntegrationTest
    test "Should login before hosting a discussion" do
        visit ('http://localhost:3000/')
        click_on('Host Discussion')
        assert_text ('Login')
    end
    test "Should sign up and then host a discussion and get redirected to new event page" do
      visit ('http://localhost:3000/')
      click_on('Sign Up', match: :first)
      fill_in(id:'user_name', with: 'name')
      fill_in(id:'user_email', with: 'e@gmail.com')
      fill_in(id:'user_permalink', with:'username')
      fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
      fill_in(id:'user_password_confirmation', with:'password')
      click_on(class: 'form-control btn-primary')#Click Signup
      assert_text ('Profile Image')#is user sent to their profile info page?
      visit ('http://localhost:3000/')
      click_on('Host Discussion')
      fill_in(id:'event_name', with: 'Intern')
      fill_in(id:'event_desc', with: 'This is a description of the event')
      click_button('Create Event')
      assert_text('Intern')#does the event show up on the homepage?
      click_on('Sign out')
      click_on('Join Discussion')
      assert_text('Live Show')
    end
    test "Should redirect after host a discussion is clicked" do
         visit ('http://localhost:3000/')
         
    end

end
