require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest
    test "Should login before hosting a discussion" do
        visit ('http://localhost:3000/')
        click_on('Host Discussion')
        assert_text ('Login')
    end
    test "Should sign up and then host a discussion and get redirected to new event page" do
        visit ('http://localhost:3000/')
        click_on('Sign Up', match: :first)
        fill_in('Name', with: 'name')
        fill_in('Email', with: 'e@mail.com')
        fill_in('Username', with:'username')
        fill_in("Password", with: 'password', :match => :prefer_exact)
        fill_in(id:"user_password_confirmation", with:'password')
        click_on(class: 'form-control btn-primary')
        click_on('Home')
        click_on('Host Discussion')
        assert_text ('Create an Event')
    end
     test "Should join a discussion" do
     end

end
