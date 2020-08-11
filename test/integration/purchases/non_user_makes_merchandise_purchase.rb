require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class NonUserMakesMerchandisePurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @test_user = users :confirmedUser
    @merchandise = merchandises(:one_empty_attachments)
    @merchandise_with_attachment = merchandises(:one_with_attachment)
    @visit_new_purchase          = lambda { |merchandise_id| visit new_purchase_path merchandise_id: merchandise_id }
    visit "/#{@test_user.permalink}"
  end


  test 'non user makes merchandise purchase with new card no attachment' do
    first(class: 'btn btn-warning').click
    assert page.has_css? '#purchase_email'
    fill_in id: 'purchase_email', with: "test@gmail.com"
    assert page.has_css? '#card_number'
    fill_in id: 'card_number',          with: "4242424242424242"
    assert page.has_css? '#card_code'
    fill_in id: 'card_code',            with: "123"
    assert page.has_css? '#card_month'
    select '1 - January',                from: 'card_month'
    assert page.has_css? '#card_year'
    select '2020',                      from: 'card_year'
    click_on 'Purchase'
    # issue with the testing card, should redirect to seller's page
    assert_current_path "/purchases"
  end
  
  test 'non user makes a merchandise purchase with attachments' do
    @visit_new_purchase.call @merchandise_with_attachment.id
    fill_in id: 'purchase_email', with: "onetimeemail@email.com"
    card_information_entry
    assert page.has_button? 'Purchase'
    click_on 'Purchase'
    assert_current_path "/purchases"
  end
end
