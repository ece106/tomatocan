require 'test_helper'
require 'capybara-screenshot/minitest'
class MerchandisesTest < ActionDispatch::IntegrationTest
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    Capybara::Screenshot.autosave_on_failure = false
    setup do
    visit ('/')
    click_on('Sign In', match: :first)
    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')
    click_on(class: 'form-control btn-primary')
end
    test 'Should create reward from controlpanel rewards page' do
        # signUpUser()
        # signInUser()
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert_text('Describe this Reward or donation.')#This text appears in the new merchandises page
    end
    test 'Should render current buy reward from profileinfo page' do
        click_on(text: 'name',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        fill_in(id: 'merchandise_name', with: 'Tickets to My Show')
        fill_in(id: 'merchandise_price', with: '30')
        #purchase deadline is currently 2019 July 24
        click_on(id: 'perkSubmit')
        assert_text('Tickets to My Show')
    end
    test 'Should render current donate reward from profileinfo page' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        select('Donate', from: 'merchandise_buttontype')
        fill_in(id: 'merchandise_name', with: 'Googitygoo')
        fill_in(id: 'merchandise_price', with: '30')
        #purchase deadline is currently 2019 July 24
        click_button('Create Reward')
        assert_text('Googitygoo')
    end
    test "Should meet all requirements creating new reward" do
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
    test 'Should_not_meet_all_requirements_when_creating_new_reward' do 
        click_on('Phineas')
        click_on('Control Panel')
        click_on('Rewards')
        #purchase deadline is currently 2019 July 24
        click_on(class: 'btn btn-lg btn-warning', match: :first)
        click_on(class: 'btn btn-lg btn-primary')
        assert_text('errors prohibited this Reward from being saved:')
    end
    test 'Should_render_reward_description' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        fill_in(id: 'merchandise_name', with: 'This is a lovely show name. WOW!')
        fill_in(id: 'merchandise_price', with: '30')
        fill_in(id: 'merchandise_desc', with: 'This is a lovely description. WOW!')
        #purchase deadline is currently 2019 July 24
        click_on(id: 'perkSubmit')
        assert_text('This is a lovely description. WOW!')
    end
    test 'Should_show_type_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_buttontype')
    end
    test 'Should_show_title_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_name')
    end
    test 'Should_show_price_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_price')
    end
    test 'Should_show_description_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_desc')
    end
    test 'Should_show_image_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_itempic')
    end
    test 'Should_show_youtube_URL_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_youtube')
    end
    test 'Should_show_year_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_deadline_1i')
    end
    test 'Should_show_day_field_when_creating_new_reward' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Rewards')
        click_on('Create Reward')
        assert page.has_field?('merchandise_deadline_3i')
    end
end
