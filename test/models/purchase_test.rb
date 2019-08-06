require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  setup do
    # The seller
    @seller = users :seller

    # User 'Buy'
    @buyer                       = users :buyer
    @merchandise_with_attachment = merchandises :merchandise_with_attachment
    @merchandise_purchase        = purchases :merchandise_purchase
    @merchandise_purchase.update_attribute(:merchandise_id, @merchandise_with_attachment.id)

    # Anonymous 'Buy'
    @anon_merch_purchase = purchases :anonymous_merchandise_purchase
    @anon_merch_purchase.update_attribute(:merchandise_id, @merchandise_with_attachment.id)

    # User 'Donate'
    @donator                 = users :donator
    @merchandise_as_donation = merchandises :merchandise_as_donation
    @donation_purchase       = purchases :donation_purchase
    @donation_purchase.update_attribute(:merchandise_id, @merchandise_as_donation.id)

    # Anonymous 'Donation'
    @anon_donation_purchase = purchases :anon_donation_purchase
    @anon_donation_purchase.update_attribute(:merchandise_id, @merchandise_as_donation.id)
  end

  test '#calculate_amount returns the correct value' do
    expected_value = @merchandise_purchase.send(:calculate_amount, @merchandise_with_attachment.price)
    assert_equal expected_value, 700
  end

  test '#calculate_authorcut returns the correct value' do
    expected_value = @merchandise_purchase.send(:calculate_authorcut, @merchandise_with_attachment.price)
    assert_equal expected_value, 6.14
  end

  test '#calculate_application_fee returns the correct value' do
    amount = @merchandise_purchase.send(:calculate_amount, @merchandise_with_attachment.price)
    expected_app_fee = @merchandise_purchase.send(:calculate_application_fee, amount)
    assert_equal expected_app_fee, 35
  end

  test '#purchase_anonymous? for donation_purchase should return true' do
    assert_equal @anon_donation_purchase.send(:purchase_anonymous?), true
  end

  test '#purchase_anonymous? for merchandise_purchase should return false' do
    assert_equal @merchandise_purchase.send(:purchase_anonymous?), false
  end

  test '#anonymous_merchandise_payment' do
    @anon_merch_purchase.send(:purchase_anonymous?)

    # Setup payment information
    @anon_merch_purchase.setup_payment_information

    # Create and update purchase with token
    stripe_card_token = create_token
    @anon_merch_purchase.stripe_card_token = stripe_card_token.id

    # Create charge
    charge = @anon_merch_purchase.anonymous_merchandise_payment

    # Assert charge
    assert_not_nil charge, 'Stripe Charge object should not be nil.'
  end

  test '#anonymous_donation' do
    @anon_donation_purchase.send(:purchase_anonymous?)

    # Setup payment information
    @anon_donation_purchase.setup_payment_information

    # Create and update purchase with token
    stripe_card_token = create_token
    @anon_donation_purchase.stripe_card_token = stripe_card_token.id

    # Create charge
    charge = @anon_donation_purchase.anonymous_donation

    # Assert charge
    assert_not_nil charge, 'Stripe Charge object should not be nil.'
  end

  test '#returning_customer' do
    # Setup payment information
    @merchandise_purchase.setup_payment_information

    # Create the token for the source
    stripe_card_token = create_token
    @merchandise_purchase.stripe_card_token = stripe_card_token.id

    # Process buyer so buyer has a stripe_customer_token
    @merchandise_purchase.first_time_buyer(@buyer)

    # Returning charge
    returning_charge = @merchandise_purchase.returning_customer(@buyer)

    # Assert
    assert_not_nil returning_charge, 'Charge object should not be nil for returning customer.'
  end

  test '#returning_donator' do
    # Setup payment information
    @donation_purchase.setup_payment_information

    # Create the token for the source
    stripe_card_token = create_token
    @donation_purchase.stripe_card_token = stripe_card_token.id

    # Process buyer so buyer has a stripe_customer_token
    @donation_purchase.first_time_donator(@donator)

    # Returning charge
    returning_charge = @donation_purchase.returning_donator(@donator)

    # Assert
    assert_not_nil returning_charge, 'Charge object should not be nil for returning customer.'
  end

  test '#retrieve_customer_card for donation' do
    # Setup payment information
    @donation_purchase.setup_payment_information

    # Create the token for the source
    stripe_card_token = create_token
    @donation_purchase.stripe_card_token = stripe_card_token.id

    # Process buyer so buyer has a stripe_customer_token
    @donation_purchase.first_time_donator(@donator)

    # Retrieve customer card
    card = @donation_purchase.retrieve_customer_card(@donator)

    assert_not_nil card, 'Card should not be nil'
  end

  test '#save_with_payment should throw Stripe InvalidRequestError' do
    assert_raise Stripe::InvalidRequestError do
      @donation_purchase.returning_donator(@donator)
    end
  end

  # WIP
  test '#save_with_payment for donation' do
    stripe_card_token_id = create_token.id
    @donation_purchase.update_attribute(:stripe_card_token, stripe_card_token_id)
    @donation_purchase.save_with_payment
  end

  # WIP
  test '#save_with_payment for merchandise purchase' do
    stripe_card_token_id = create_token.id
    @merchandise_purchase.update_attribute(:stripe_card_token, stripe_card_token_id)
    @merchandise_purchase.save_with_payment
  end

  private

  def create_token
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
