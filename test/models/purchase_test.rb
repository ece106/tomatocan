require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  setup do
    # The seller
    @seller = users :seller

    # Domain Logic involving 'Buy'
    @buyer                       = users :buyer
    @merchandise_with_attachment = merchandises :merchandise_with_attachment
    @merchandise_purchase        = purchases :merchandise_purchase

    @merchandise_purchase.update_attribute(:merchandise_id, @merchandise_with_attachment.id)

    # Domain Logic involving 'Donate'
    @donator                 = users :donator
    @merchandise_as_donation = merchandises :merchandise_as_donation
    @donation_purchase       = purchases :donation_purchase

    @donation_purchase.update_attribute(:merchandise_id, @merchandise_as_donation.id)
  end

  test 'calculate_amount returns the correct value' do
    expected_value = @merchandise_purchase.calculate_amount(@merchandise_with_attachment.price)
    assert_equal expected_value, 700
  end

  test 'calculate_authorcut returns the correct value' do
    expected_value = @merchandise_purchase.calculate_authorcut(@merchandise_with_attachment.price)
    assert_equal expected_value, 6.14
  end

  test 'calculate_application_fee returns the correct value' do
    amount = @merchandise_purchase.calculate_amount(@merchandise_with_attachment.price)
    expected_app_fee = @merchandise_purchase.calculate_application_fee(amount)
    assert_equal expected_app_fee, 35
  end

  test 'purchase_anonymous? for donation_purchase should return true' do
    assert_equal @donation_purchase.purchase_anonymous?, true
  end

  test 'purchase_anonymous? for merchandise_purchase should return false' do
    assert_equal @merchandise_purchase.purchase_anonymous?, false
  end

  test 'retrieve_customer_card should return the correct card' do
    binding.pry
    stripe_card_token_id = create_token_for_anonymous.id
    @donation_purchase.update_attribute(:stripe_card_token, stripe_card_token_id)
    @donation_purchase.save_with_payment
    binding.pry
  end

  private

  def create_token_for_anonymous
    Stripe::Token.create({
      card: {
        number: "4242424242424242",
        exp_month: 8,
        exp_year: 2060,
        cvc: "123"
      }
    })
  end
end
