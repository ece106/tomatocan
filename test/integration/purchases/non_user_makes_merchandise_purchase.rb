require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class NonUserMakesMerchandisePurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase                    = purchases(:one)
    @user_one                    = users(:one)
    @card_number                 = "4242424242424242"
    @cvc                         = "123"
    @merchandise                 = merchandises(:one)
    @merchandise_with_attachment = merchandises(:one_with_attachment)
    @visit_new_purchase          = lambda { |merchandise_id| visit new_purchase_path merchandise_id: merchandise_id }

  end

  #test 'non user enters in wrong information card declined' do
    #@visit_new_purchase.call @merchandise.id
    #assert page.has_css? '#purchase_email'
    #fill_in id: 'purchase_email',   with: "onetimeemail@email.com"
    #click_on 'Purchase'
    #assert @purchase.errors.any?
  #end

  test 'non user makes merchandise purchase with new card no attachment' do
    @visit_new_purchase.call @merchandise.id
    assert page.has_css? '#purchase_email'
    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    card_information_entry
    assert page.has_button? 'Purchase'
    click_on 'purchase-btn'
    assert_current_path "/#{@user_one.permalink}"
  end
  
  test 'non user makes a merchandise purchase with attachments' do
    @visit_new_purchase.call @merchandise_with_attachment.id
    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    card_information_entry
    assert page.has_button? 'Purchase'
    click_on 'Purchase'
    #assert that the merchandise is sendindd
  end

end
