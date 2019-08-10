require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class UserCreatesDonationPurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase = purchases(:one)
    @user_one = users(:one) 
    @user_two = users(:two)
    @card_number = "4242424242424242" 
    @cvc = "123"

  end

  test 'user makes a dontation with a new card' do
    user_sign_in @user_two
    visit "/#{@user_one.permalink}" 
    click_on 'Donate'
    card_information_entry
    click_on 'Donate'   
    assert_equal "/#{@user_one.permalink}", current_path
  end
  
  test 'user makes a donation with stripe_card_token present ' do
    user_sign_in
    
 

  end

  #non user makes a donation
  
  def user_sign_in  user
    visit root_path 
    click_on 'Sign In' 
    fill_in id: 'user_email', with: "#{user.email}"
    fill_in id: 'user_password', with: "#{user.password}"
    click_on class: 'form-control btn-primary'
  end

  def card_information_entry 
    fill_in id: 'card_number', with: "#{@card_number}"
    fill_in id: 'card_code', with: "#{@cvc}"
    select 'August', from: 'card_month'
    select '2024', from: 'card_year'
  end 

end 
