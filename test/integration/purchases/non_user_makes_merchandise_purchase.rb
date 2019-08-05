require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class NonUserMakesMerchandisePurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase = purchases(:one)
    @user_one = users(:one) #seller is a user 
    @card_number = "4242424242424242" 
    @cvc = "123"
    @merchandise = merchandises(:one)
  end

  test 'non user enters in wrong information card declined' do
    visit new_purchase_path merchandise_id: @merchandise.user_id
    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    fill_in id: 'card_number', with: "#{SecureRandom.alphanumeric(16)}" #wrong credit card info 
    click_on 'purchase-btn'
    assert has_css? '#stripe_error'
    assert_raises('e') {click_on 'purchase-btn'}
  end

  test 'non user makes merchandise purchase with new card' do
    visit new_purchase_path merchandise_id: @merchandise.user_id 
    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    card_information_entry
    click_on 'purchase-btn' 
    assert_equal "/#{@user_one.permalink}", current_path
    refute has_css? '#stripe_error'
  end

  private

  def card_information_entry 
    fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
    fill_in id: 'card_number', with: "#{@card_number}" 
    fill_in id: 'card_code', with: "#{@cvc}"
    select 'August', from: 'card_month'
    select '2024', from: 'card_year'
  end

end
