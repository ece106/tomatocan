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

    #Pruchase no merchandises
    @donation_no_merchandise = purchases :donation_no_merchandise

    # Card
    @stripe_card_token = create_token

  end

  #VALIDATIONS
  test "author_id presence" do
    newPurchase = Purchase.create(pricesold: 12.0, authorcut: 10);
    assert_not newPurchase.valid?
    assert_not_empty newPurchase.errors[:author_id]
  end

  test "pricesold presence" do
    newPurchase = Purchase.create(author_id: 1, authorcut: 10);
    assert_not newPurchase.valid?
    assert_not_empty newPurchase.errors[:pricesold]
  end

  test "authorcut presence" do
    newPurchase = Purchase.create(author_id: 1, pricesold: 12.0);
    assert_not newPurchase.valid?
    assert_not_empty newPurchase.errors[:authorcut]
  end

  #Unit test
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
    expected_app_fee = @merchandise_purchase.send(:calculate_application_fee_amount, amount)
    assert_equal expected_app_fee, 35
  end

  test '#is_anonymous?' do
    assert @anon_donation_purchase.is_anonymous?, message: "is_anonymous? should return true for anon_donation_purchase"
    assert_not @merchandise_purchase.is_anonymous?, message: "is_anonymous? should return false for anon_donation_purchase"
  end

  test '#anonymous_charge' do
    # Setup payment information
    @anon_merch_purchase.setup_payment_information

    # Initialize card token
    @anon_merch_purchase.stripe_card_token = @stripe_card_token.id

    # Create charge
    charge = @anon_merch_purchase.anonymous_charge

    # Assert charge
    assert_not_nil charge, 'Stripe Charge object should not be nil.'
    assert_equal charge.status, 'succeeded'
  end

  test "#user_merchandise_payment" do
    returning_or_first_time(@merchandise_purchase) {@merchandise_purchase.user_merchandise_payment}
  end

  test '#user_donation' do
    returning_or_first_time(@donation_purchase) {@donation_purchase.user_donation}
  end

  test '#customer_first_time_and_returning' do
    # Setup payment information
    @merchandise_purchase.setup_payment_information

    # Initialize card token
    @merchandise_purchase.stripe_card_token = @stripe_card_token.id

    # Process buyer so buyer has a stripe_customer_token
    first_time_charge = @merchandise_purchase.first_time_buyer(@buyer)
    returning_charge = @merchandise_purchase.returning_customer(@buyer)

    assert_not_empty @buyer.stripe_customer_token, 'First time customer token should have been created'

    assert_not_nil returning_charge, 'Charge object should not be nil for returning customer.'
    assert_equal returning_charge.status, 'succeeded', 'Returning customer charge should have succeeded.'
  end

  test '#donator_first_time_and_returning' do
    # Setup payment information
    @donation_purchase.setup_payment_information

    # Initialize card token
    @donation_purchase.stripe_card_token = @stripe_card_token.id

    first_time_charge = @donation_purchase.first_time_donator(@donator)
    returning_charge = @donation_purchase.returning_donator(@donator)

    assert_not_empty @donator.stripe_customer_token, 'First time donator token should have been created'

    assert_not_nil returning_charge, 'Charge object should not be nil for returning customer.'
    assert_equal returning_charge.status, 'succeeded'
  end

  test '#merchandise_buy_or_donate?' do
    #initializing local @merchandise variable
    @merchandise_purchase.setup_payment_information
    @donation_purchase.setup_payment_information

    assert_not @donation_purchase.merchandise_buy_or_donate?
    assert @merchandise_purchase.merchandise_buy_or_donate?
  end

  test '#retrieve_customer_card for donation' do
    # Setup payment information
    @donation_purchase.setup_payment_information

    # Initialize card token
    @donation_purchase.stripe_card_token = @stripe_card_token.id

    # Process buyer so buyer has a stripe_customer_token
    @donation_purchase.first_time_donator(@donator)

    # Retrieve customer card
    card = @donation_purchase.retrieve_customer_card(@donator)

    assert_not_nil card, 'Card should not be nil'
    assert_equal card.id, @stripe_card_token[:card][:id]
  end

  test '#save_with_payment should throw Stripe InvalidRequestError' do
    assert_raise Stripe::InvalidRequestError do
      @donation_purchase.returning_donator(@donator)
    end
  end

  test '#donation_payment' do
    payment_flow_test(@anon_donation_purchase, @donation_purchase, :donation_payment)
  end

  test '#merchandise_payment' do
    payment_flow_test(@anon_merch_purchase, @merchandise_purchase, :merchandise_payment)
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

  def returning_or_first_time(purchase)
    purchase.stripe_card_token = @stripe_card_token.id
    purchase.setup_payment_information
    yield
    user = User.find(purchase.user_id)

    assert_not_empty user.stripe_customer_token

    assert_no_changes -> {user.stripe_customer_token}, "stripe_customer_token should not change" do
      yield
    end
  end

  def payment_flow_test(anon_purchase, user_purchase, charge_function)
    #anonymous payment
    anon_purchase.setup_payment_information
    anon_purchase.stripe_card_token = create_token.id
    anonCharge = anon_purchase.send(charge_function)
    assert_not_nil anonCharge, "Anonymous #{charge_function} charge shall not be nil"

    #user payment (first_time_user)
    user_purchase.setup_payment_information
    user_purchase.stripe_card_token = create_token.id
    userCharge = user_purchase.send(charge_function)
    assert_not_nil userCharge, "User #{charge_function} charge shall not be nil"
    assert_not_empty User.find(user_purchase.user_id).stripe_customer_token, "Anonymous #{charge_function} charge shall not be nil"
  end
end
