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

  test "pricesold should equal merchandise price" do
    @purchase.pricesold = @merchandise.price
    assert_equal @purchase.pricesold, @merchandise.price
  end

  test "seller should not be nil" do
    seller = @user
    assert_not_nil seller
  end

  test "description should equal merchandise name" do
    desc = @merchandise.name
    assert_equal desc, @merchandise.name
  end

  test "amount should be the correct value" do
    amt = (@merchandise.price * 100).to_i
    expected_amt = 150
    assert_equal expected_amt, amt
  end

  # L78 models/purchase.rb
  test "authorcut should have correct value" do
    pricesold           = @merchandise.price
    @purchase.authorcut = ((pricesold * 92.1).to_i - 30).to_f/100 # => 1.08
    expected_authorcut  = 1.08
    assert_equal expected_authorcut, @purchase.authorcut, "authorcut should equal expected value."
  end

  # NOTE: Broke up calculations for groupcuts/authorcuts into granular method
  # to make it easier to test
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

end
