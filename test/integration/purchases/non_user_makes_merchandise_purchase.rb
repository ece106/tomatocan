require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class NonUserMakesMerchandisePurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase                    = purchases(:two)
    @user_one                    = users(:one)
    @card_number                 = "4242424242424242"
    @cvc                         = "123"
    @merchandise                 = merchandises(:one)
    @merchandise_with_attachment = merchandises(:one_with_attachment)

  end

  test 'non user enters in wrong information card declined' do
    visit_new_purchase @merchandise.id
    assert page.has_css? '#purchase_email'
    fill_in id: 'purchase_email',   with: "onetimeemail@email.com"
    click_on 'Purchase'
    assert page.has_css? '#stripe_error'
  end

  test 'non user makes merchandise purchase with new card no attachment' do
    visit_new_purchase @merchandise.id
    assert page.has_css? '#purchase_email'
    fill_in id: 'purchase_email',   with: "onetimeemail@email.com"
    card_information_entry
    assert page.has_button? 'Purchase'
    click_on 'Purchase'
  end
  
  test 'non user makes a merchandise purchase with attachments' do
    visit_new_purchase @merchandise_with_attachment.id
    fill_in id: 'purchase_email',   with: "onetimeemail@email.com"
    card_information_entry
    assert page.has_button? 'Purchase'
    click_on 'Purchase'
    #assert the recipt page  
    #assert that the merchandise is sending
  end

  private

  def visit_new_purchase merchandise_id 
    #visit "/#{seller.permalink}"
    #find(:link, "#{merchandise.buttontype} for $#{merchandise.price}0!", match: :first).click
    visit new_purchase_path merchandise_id: merchandise_id
    
  end


  def card_information_entry 
    fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
    fill_in id: 'card_number',          with: "#{@card_number}"
    fill_in id: 'card_code',            with: "#{@cvc}"
    select 'August',                    from: 'card_month'
    select '2024',                      from: 'card_year'
  end

end
