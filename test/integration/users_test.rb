require 'test_helper'
require 'capybara-screenshot/minitest'
class UsersTest < ActionDispatch::IntegrationTest
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    Capybara::Screenshot.autosave_on_failure = false
    setup do
    visit ('http://localhost:3000/')
    def signUpUser()
        visit ('http://localhost:3000/')
        click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: 'name')
        fill_in(id:'user_email', with: 'e@gmail.com')
        fill_in(id:'user_permalink', with:'username')
        fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'password')
        click_on(class: 'form-control btn-primary')
        click_on('Sign out')
    end
    def signInUser()
        visit ('http://localhost:3000/')
        click_on('Sign In', match: :first)
        fill_in(id:'user_email', with: 'e@gmail.com')
        fill_in(id:'user_password', with: 'password')
        click_on(class: 'form-control btn-primary')
    end
end
test "Should_view_profileinfo" do
    click_on('Discover Talk Show Hosts')
    assert_text ('Discussion Hosts')
end
test "Should_sign_up" do
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    assert_text ('Sign out')
end
test "Should_sign_up_and_then_out" do
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    click_on('Sign out')
    assert_text('Sign Up')
end
test "Should_sign_up_and_then_out_and_then_back_in" do
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    click_on('Sign out')
    click_on('Sign In')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    click_on(class: 'form-control btn-primary')
    assert_text ('Sign out')
    
end
#todo: write a test that fails to sign up
test "Should_see_edit_profile_in_control_panel" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    assert_text('Edit Profile')
end
#test "Should_change_about" do
#    signUpUser()
#    signInUser()
#    click_on(class: 'dropdown-toggle')
#    click_on('Control Panel')
#    fill_in(id:'user_about',with:'Sample Desc')
#    click_on(id:'saveProfileButton',:match => :first)
#    assert_text('Sample Desc')
#end
test "Should_change_genre1" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre1',with:'Genre1')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre1')
end
test "Should_change_genre2" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre2',with:'Genre2')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre2')
end
test "Should_change_genre3" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre3',with:'Genre3')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre3')
end
test "Should_change_password" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    click_on('Change Password')
    fill_in(id:'user_password_confirmation',with: 'password1', :match => :prefer_exact)
    fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
    click_on("Save Profile")
    click_on('Sign out')
    click_on('Sign In', match: :first)
    fill_in(id:'user_email', with: 'e@gmail.com')
    fill_in(id:'user_password', with: 'password1')
    click_on(class: 'form-control btn-primary')
    assert_text('CrowdPublish.TV is for nonprofits,')
end
test "Should_change_email" do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    fill_in(id:'user_email', with: 'e2@mail.com')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Videos')
end
test "Should_not_change_email"do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    fill_in(id:'user_email', with: 'e2')
    click_on(id:'saveProfileButton',:match => :first)
    refute_title('Videos')
end
test "Should_show_video" do
    click_on('Discover Talk Show Hosts')
    assert_text('Phineas')
end
test "Should_not_show_video" do
    click_on('Discover Talk Show Hosts')
    refute_title('name2')
    
end
test "Should_not_show_other_controlpanel" do
    visit('http://localhost:3000/user1/controlpanel')
    refute_title('Edit Profile')
end
test 'Should_fail_change_password' do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    click_on('Change Password')
    fill_in(id:'user_password_confirmation',with: 'password', :match => :prefer_exact)
    fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
    click_on("Save Profile")
    assert_text('Passwords do not match')
end
#These tests are in progress
test 'Should_see_product' do
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    assert_text('user1 product')
end
test 'Should_change_name' do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_name', with:'names')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('names')
end
test 'Should_cancel' do
    signUpUser()
    signInUser()
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on(id:"cancelProfileButton",:match => :first)
    assert_text("name's Videos")
end
#Stripe error here
test 'Should_buy_user' do
    visit('http://localhost:3000/')
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    click_on('Buy for $1.50')
    fill_in(id:'card_number', with:'4242424242424242')
    select("2020", from: 'card_year')
    click_on('Purchase')
    assert_text('successfully')
end
test 'Should_donate_user' do
    visit('http://localhost:3000/')
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    click_on('Donate $2.00!')
    fill_in(id:'card_number', with:'4242424242424242')
    select("2020", from: 'card_year')
    click_on('Purchase')
    assert_text('successfully')
end
test 'Should order' do
    visit('http://localhost:3000/')
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    click_on('Buy for $1.50')
    assert_text('If you are purchasing')
end
test 'Should_host_logged_in' do
    signUpUser()
    signInUser()
    click_on('Host A Show')
    fill_in(id:'event_name', with:'example')
    select('2020', from:'event_start_at_1i')
    select('December', from:'event_start_at_2i')
    select('31', from:'event_start_at_3i')
    select('01 AM', from:'event_start_at_4i')
    select('00', from:'event_start_at_5i')
    select('2020', from:'event_end_at_1i')
    select('December', from:'event_end_at_2i')
    select('31', from:'event_end_at_3i')
    select('01 AM', from:'event_end_at_4i')
    select('00', from:'event_end_at_5i')
    find(class:'btn btn-lg btn-primary').click
    #click_on(class: 'btn btn-lg btn-primary')
    #assert_text('example')
end
test 'Should_host_logged_out' do
    click_on('Host A Show')
    assert_text('You need to sign in or sign up before continuing.')
end
test 'Should_see_sign_up_not_logged_in' do
    within('div#heroImage.row') do
        assert_text('Sign Up')
    end
end
test 'Should_see_offer_rewards_logged_in' do
    signUpUser()
    signInUser()
    within('div#heroImage.row') do
        assert_text('Offer Rewards')
    end
end
#test number of panels



end
