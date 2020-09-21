require 'test_helper'

class PurchasesHelperTest < ActionView::TestCase
  setup do
    @card_number           = "4242424242424242"
    @cvc                   = "123"
    @visit_new_donation    = lambda { |donation_id| visit new_purchase_path  merchandise_id: donation_id }
    @visit_deault_donation = lambda { |price, author_id| visit new_purchase_path  author_id: author_id, pricesold: price }
  end

  def user_sign_in  user
    visit root_path
    click_on 'Sign In'
    fill_in id: 'user_email',    with:  "#{user.email}"
    fill_in id: 'user_password', with:  "#{user.password}"
    binding.pry
    click_on class: 'form-control btn-primary'
  end

  def card_information_entry
    fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
    fill_in id: 'card_number',          with: "#{@card_number}"
    fill_in id: 'card_code',            with: "#{@cvc}"
    select 'August',                    from: 'card_month'
    select '2024',                      from: 'card_year'
  end
end
