require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class NonUserMakesMerchandisePurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase = purchases(:two)
    @user_one = users(:one) 
    @card_number = "4242424242424242" 
    @cvc = "123"
    @merchandise = merchandises(:one)

  end

  test 'non user enters in wrong information card declined' do
    visit "/#{@user_one.permalink}"
    first(:link, "#{@merchandise.buttontype} for $#{@merchandise.price}0!").click

    assert page.has_css? '#purchase_email'

    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    click_on 'Purchase'

    assert @purchase.errors.any?

    assert_current_path new_purchase_path merchandise_id: @merchandise.id
  end

  test 'non user makes merchandise purchase with new card' do
    visit "/#{@user_one.permalink}"
    first(:link, "#{@merchandise.buttontype} for $#{@merchandise.price}0!").click
    
    assert page.has_css? '#purchase_email'

    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    card_information_entry

    assert page.has_button? 'Purchase'

    click_on 'Purchase'

    refute @purchase.errors.any? 

    #assert current path when recipts are done
    
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
