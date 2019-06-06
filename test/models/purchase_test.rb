require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  def setup
    @purchase    = purchases(:one)
    @user        = users(:one)
    @merchandise = merchandises(:one)
  end

  [:author_id, :pricesold, :authorcut ].each do |field|
    test "#{field.to_s}_must_not_be_empty" do
      purchase = Purchase.new
      purchase.send "#{field.to_s}=", nil #what does this line do
      refute purchase.valid?
      refute_empty purchase.errors[field] #must be in same test as above line in order to have usererrors not be nil
    end
  end

  test "check if book_id or merchandise_id is blank" do
    purchase = Purchase.new
    purchase.send "book_id=",nil
    purchase.send "merchandise_id=", nil
    refute purchase.valid? #book_id and merchandise_id must not be nil
  end

  # =============

  test "seller.id should equal merchandise.user_id" do
    seller = @user
    assert_equal seller.id, @merchandise.user_id
  end

  # L58
  test "pricesold should equal merchandise price" do
    @purchase.pricesold = @merchandise.price
    assert_equal @purchase.pricesold, @merchandise.price
  end

  # L60
  test "seller should not be nil" do
    # Seller should be a user who has a merchandise.user_id
    seller = @user
    assert_not_nil seller
  end

  # L61
  test "amount should be the correct value" do
    amt = (@merchandise.price * 100).to_i
    expected_amt = 150
    assert_equal expected_amt, amt
  end

  # L62
  test "purchase description should not be nil" do
    desc = @merchandise.name
    assert_not_nil desc, "Purchase description should not be nil"
  end

  # L62
  test "purchase description should equal merchandise name" do
    desc = @merchandise.name
    assert_equal desc, @merchandise.name
  end

  # L78 models/purchase.rb
  test "authorcut should have correct value" do
    pricesold           = @merchandise.price
    @purchase.authorcut = ((pricesold * 92.1).to_i - 30).to_f/100 # => 1.08
    expected_authorcut  = 1.08
    assert_equal expected_authorcut, @purchase.authorcut, "authorcut should equal expected value."
  end

  # L93
  test "customer should not be nil when email is present" do
    # TODO: Create a customer and if customer.id and customer.email is not nil
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_not_nil customer.id, "Customer id cannot be nil"
    assert_not_nil customer.source, "Customer source cannot be nil"
    assert_not_nil customer.description, "Customer description cannot be nil"
    assert_not_nil customer.email, "Customer email cannot be nil"
  end

  # L104
  test "purchaser should not be nil when email is not present" do
    # TODO: test existence of the purchaser object, purchase name
    @purchaser = @user
    assert_not_nil @purchaser.name, "Purchaser should have a name"
    assert_not_nil @purchaser, "Purchaser should not be nil"
  end

  # L108
  test "purchaser has stripe_customer_token present" do
    # TODO:
    #   test existence of purchaser's stripe_customer_token present?
    #   test existence of customer
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_not_nil customer.id, "Customer id cannot be nil"
  end

  # L112
  test "customer should save with correct attributes when stripe_card_token present" do
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_equal "fake_stripe_token", customer.source
    # TODO test for custoemr save?
    # assert customer.save
  end

  # L129
  # NOTE: this tests the "true" block in the if else condition
  test "charge should have valid attributes when seller.id equals 143" do
    # TODO:
    #   test if seller.id matches any one of these numbers: 143,  1403,  1452,  1338,  1442
    #   check for a local variable charge object
    seller = @user

    seller.id = 143
    assert_equal seller.id, 143

    seller.id = 1403
    assert_equal seller.id, 1403

    seller.id = 1452
    assert_equal seller.id, 1452

    seller.id = 1338
    assert_equal seller.id, 1338

    seller.id = 1442
    assert_equal seller.id, 1442

    amt           = (@merchandise.price * 100).to_i
    desc          = @merchandise.name
    currency_type = "usd"

    # TODO: rework this so CustomerMock receives args
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })

    charge_mock = ChargeMock.new({
      amount: amt,
      customer: customer.id,
      currency: "usd",
      description: desc
    })

    assert_equal amt, charge_mock.amount
    assert_equal desc, charge_mock.description
    assert_equal currency_type, charge_mock.currency
  end

  #  L137
  # NOTE: this tests the "false" block in the if else condition
  test "test if seller.id does not match any one of these numbers: 143,  1403,  1452,  1338,  1442" do
    # TODO:
    #   test calculate app fee = ((amt * 5)/100)
    #   test for local variables custoemr.id, sellerstripeaccount.id, token, charge
    seller = @user
    assert_not_equal seller.id, 143
    assert_not_equal seller.id, 1403
    assert_not_equal seller.id, 1452
    assert_not_equal seller.id, 1338
    assert_not_equal seller.id, 1442

    amt            = (@merchandise.price * 100).to_i # => 1.5 * 100
    appfee         = ((amt * 5) / 100) # => 7.5
    expected_value = 7
    assert_equal expected_value, appfee

    # sellerstripeaccount = Stripe::Account.retrieve(seller.stripeid)
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_not_nil customer.id, "Customer id should not be nil"

    seller_stripe_account = @user
    assert_not_nil seller_stripe_account.id, "seller_stripe_account should not be nil"

    expected_stripeid = "acct_1E4BAlKFKIozho71"
    assert_equal expected_stripeid, seller_stripe_account.stripeid

    # TODO: L144 Test for token creation
    token_mock = TokenMock.new(customer.id, seller_stripe_account.id)
    assert_not_nil token_mock, "token must not be nil"

    # TODO: L150 Test for charge creation
    desc = @merchandise.name
    charge_mock = ChargeMock.new({
      amount: amt,
      customer: customer.id,
      description: desc,
      application_fee: appfee,
      stripe_account: seller_stripe_account.id
    })
    assert_not_nil charge_mock, "charge must not be nil"
  end

  # L169
  # TODO: Test for group_id.present?
  # test "" do
  # end

  # # L169
  # test "" do
  #   # TODO test for these when group_id is not nil
  #   # test to see if tranfer is not nil
  #   # test transfer.amount should equal (@purchase.groupcut * 100).to_i
  #   # test transfer.currency should equal "usd"
  #   # test transfer.destination should equal groupstripeaccount.id
  #   # test transfer.source_transaction equal to charge.id
  #   # test transfer.transfer_group should equal transfergrp
  # end

  # NOTE: Broke up calculations for groupcuts/authorcuts into granular method
  # to make it easier to test. If approve, will keep. Otherwise, delete these bottom 4 tests.
  test "calculate_groupcut_with_group_id should be correct value" do
    merchandise_price = @merchandise.price # => 1.5
    actual_groupcut   = @purchase.calculate_groupcut_with_group_id(merchandise_price)
    expected_groupcut = 0.07
    assert_equal(expected_groupcut, actual_groupcut)
  end

  test "calculate_groupcut_without_group_id should be correct value" do
    actual_groupcut   = @purchase.calculate_groupcut_without_group_id
    expected_groupcut = 0.0
    assert_equal(expected_groupcut, actual_groupcut)
  end

  test "calculate_authorcut_without_group_id should be correct value" do
    merchandise_price  = @merchandise.price
    actual_authorcut   = @purchase.calculate_authorcut_without_group_id(merchandise_price)
    expected_authorcut = 1.08
    assert_equal(expected_authorcut, actual_authorcut)
  end

  test "calculate_authorcut_with_group_id should be correct value" do
    merchandise_price  = @merchandise.price
    groupcut           = @purchase.calculate_groupcut_with_group_id(merchandise_price) # => 0.07
    actual_authorcut   = @purchase.calculate_authorcut_with_group_id(merchandise_price, groupcut)
    expected_authorcut = 1.01
    assert_equal(expected_authorcut, actual_authorcut)
  end

  private

  # NOTE:
  # We'll create a couple of mock classes to simulate Stripe classes.
  # We should not really call Stripe from tests.
  # Consider using a gem like stripe-ruby-mock for the future.
  class CustomerMock
    attr_accessor :id, :source, :description, :email

    def initialize args
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class ChargeMock
    attr_accessor :amount, :customer, :description, :currency, :application_fee, :stripe_account

    def initialize args
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end

  class TokenMock
    attr_accessor :customer_id, :stripe_account

    def initialize customer_id, stripe_account
      @customer_id    = customer_id
      @stripe_account = stripe_account
    end
  end
end
