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

  # L58
  test "pricesold should equal merchandise price" do
    @purchase.pricesold = @merchandise.price
    assert_equal @purchase.pricesold, @merchandise.price
  end

  # L60
  test "seller should not be nil" do
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
    customer = Customer.new("1", "fake_stripe_token", "anonymous customer", "fake@mail.com")
    assert_not_nil customer.id, "Customer id cannot be nil"
    assert_not_nil customer.source, "Customer source cannot be nil"
    assert_not_nil customer.description, "Customer description cannot be nil"
    assert_not_nil customer.email, "Customer email cannot be nil"
  end

  # L104
  # test "" do
  #   # TODO: test existence of the purchaser object, purchase name
  # end

  # # L108
  # test "" do
  #   # TODO:
  #   #   test existence of purchaser's stripe_customer_token present?
  #   #   test existence of customer
  # end
  # 
  # # L112
  # test "" do
  #   # TODO:
  #   #   test if stripe_card_token present?
  #   #   test customer.source  should have a stripe_card_token
  #   #   customer should succesfully save
  # end
  # 
  # # L129
  # test "" do
  #   # TODO: 
  #   #   test if seller.id matches any one of these numbers: 143,  1403,  1452,  1338,  1442
  #   #   check for a local variable charge object
  # end
  # 
  # # L137
  # test "" do
  #   # TODO:
  #   #   test calculate app fee = ((amt * 5)/100)
  #   #   test for local variables custoemr.id, sellerstripeaccount.id, token, charge
  # end
  # 
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

  class Customer
    attr_accessor :id, :source, :description, :email

    def initialize id, source, description, email
      @id = id
      @source = source
      @description = description
      @email = email
    end
  end
end
