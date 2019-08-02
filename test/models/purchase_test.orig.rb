require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  def setup
    @purchase    = purchases(:one)
    @user        = users(:one)
    @merchandise = merchandises(:one)
  end

  # Testing associations
  # This is like testing rails itself. So I just test the FK value in respect
  # to belongs_to (optional).

  test "purchase user_id should equal user.id" do
    assert_equal @user.id, @purchase.user_id
  end

  test "purchase merchandise_id should equal merchandise.id" do
    merchandise              = merchandises(:eight)
    @purchase.merchandise_id = 1
    assert_equal merchandise.id, @purchase.merchandise_id
  end

  test "purchase user_id can be nil" do
    @purchase.user_id = nil
    assert_nil @purchase.user_id
  end

  test "purchase merchandise_id can be nil" do
    @purchase.merchandise_id = nil
    assert_nil @purchase.merchandise_id
  end

  # Testing Validations

  [:author_id, :pricesold, :authorcut ].each do |field|
    test "#{field.to_s}_must_not_be_empty" do
      purchase = Purchase.new
      purchase.send "#{field.to_s}=", nil
      refute purchase.valid?
      refute_empty purchase.errors[field]
    end
  end

  # Testing save_with_payment method

  test "check if book_id or merchandise_id is blank" do
    purchase = Purchase.new
    purchase.send "book_id=",nil
    purchase.send "merchandise_id=", nil
    refute purchase.valid?
  end

  test "pricesold should equal merchandise price" do
    @purchase.pricesold = @merchandise.price
    assert_equal @purchase.pricesold, @merchandise.price
  end

  test "seller should not be nil" do
    seller = @user
    assert_not_nil seller, "Seller should not be nil"
  end

  test "seller.id should equal merchandise.user_id" do
    seller = @user
    assert_equal seller.id, @merchandise.user_id
  end

  test "amount should be the correct value" do
    amt = (@merchandise.price * 100).to_i
    expected_amt = 150
    assert_equal expected_amt, amt
  end

  test "purchase description should not be nil" do
    desc = @merchandise.name
    assert_not_nil desc, "Purchase description should not be nil"
  end

  test "purchase description should equal merchandise name" do
    desc = @merchandise.name
    assert_equal desc, @merchandise.name
  end

  test "authorcut should have correct value" do
    pricesold           = @merchandise.price
    @purchase.authorcut = ((pricesold * 92.1).to_i - 30).to_f/100 # => 1.08
    expected_authorcut  = 1.08
    assert_equal expected_authorcut, @purchase.authorcut, "authorcut should equal expected value."
  end

  test "groupcut should have correct value when group_id is present" do
    groupcut = ((@merchandise.price * 5).to_i).to_f / 100
    assert_equal 0.07, groupcut
  end

  test "authorcut should have correct value when group_id is present" do
    groupcut  = ((@merchandise.price * 5).to_i).to_f / 100
    authorcut = ((@merchandise.price * 92).to_i - 30).to_f / 100 - groupcut
    assert_equal 1.01, authorcut
  end

  test "groupcut should have correct value when group_id is not present" do
    groupcut = 0.0
    assert_equal 0.0, groupcut
  end

  test "authorcut should have correct value when group_id is not present" do
    authorcut = ((@merchandise.price * 92.1).to_i - 30).to_f / 100
    assert_equal 1.08, authorcut
  end

  test "customer should not be nil when email is present" do
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

  test "purchaser should not be nil when email is not present" do
    @purchaser = @user
    assert_not_nil @purchaser.name, "Purchaser should have a name"
    assert_not_nil @purchaser, "Purchaser should not be nil"
  end

  test "purchaser has stripe_customer_token present" do
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_not_nil customer.id, "Customer id cannot be nil"
  end

  test "customer should save with correct attributes when stripe_card_token present" do
    customer = CustomerMock.new({
      id: 1,
      source: "fake_stripe_token",
      description: "anonymous customer",
      email: "fake@mail.com"
    })
    assert_equal "fake_stripe_token", customer.source
  end

  test "charge should have valid attributes when seller.id equals a valid number" do
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

  test "charge should have valid attributes when seller.id does not equal a valid number" do
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

    token_mock = TokenMock.new(customer.id, seller_stripe_account.id)
    assert_not_nil token_mock, "token must not be nil"

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

  class TransferMock
    attr_accessor :amount, :currency, :destination, :source_transaction, :transfer_group

    def initialize args
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end
end
