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
    user_sign_in 
    visit new_purchase_path pricesold: @purchase.pricesold
    card_information_entry
    click_on 'Donate'   
    assert_text 'You have successfully completed the purchase!'
  end
  
  test 'user makes a donation with stripe_card_token present ' do
    user_sign_in
    
 

  end

  #non user makes a donation
  
  def user_sign_in  
    visit root_path
    click_on id: 'sign-in-btn'
    fill_in id: 'user_email', with: "dontchangethisemail@orthisfixture.entry"
    fill_in id: 'user_password', with: "user1234"
    click_on class: 'form-control btn-primary'
  end

  def card_information_entry 
    fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
    fill_in id: 'card_number', with: "#{@card_number}"
    fill_in id: 'card_code', with: "#{@cvc}"
    select 'August', from: 'card_month'
    select '2024', from: 'card_year'
  end 

 # def create_customer
  #  customer = Stripe::Customer.create(source: ,
   #                                    description:,
    #                                   email: 


    
 # end
  

end 
