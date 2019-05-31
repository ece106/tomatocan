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

  # ===============

  test "calculate_groupcut_with_group_id should be correct value" do
    merchandise_price = @merchandise.price # => 1.5
    actual_groupcut   = @purchase.calculate_groupcut_with_group_id(merchandise_price)
    expected_groupcut = 0.07
    assert_equal expected_groupcut, actual_groupcut
  end

  # NOTE: Test authorcut/groupcut with group_id present
  # test "groupcut calculation with group_id present" do
  #   merchandise_price = @merchandise.price
  #   actual_groupcut = @purchase.calculate_groupcut_without_group_id(merchandise_price)
  #   # @purchase.groupcut         = ((@merchandise.price * 5).to_i).to_f / 100
  #   expected_purchase_groupcut = 0.1
  #   assert_equal expected_groupcut, actual_groupcut
  # end

  # test "authorcut calculation with group_id present" do
  #   @purchase.groupcut          = ((@merchandise.price * 5).to_i).to_f / 100 # => 0.1
  #   @purchase.authorcut         = ((@merchandise.price * 92).to_i - 30).to_f / 100 - @purchase.groupcut # => 1.44
  #   expected_purchase_authorcut = 1.44
  #   assert_equal expected_purchase_authorcut, @purchase.authorcut
  # end

  # # NOTE: Test authorcut/groupcut with no group_id present
  # test "groupcut calculation with no group_id presents should equal zero" do
  #   @purchase.groupcut         = 0.0
  #   expected_purchase_groupcut = 0.0
  #   assert_equal expected_purchase_groupcut, @purchase.groupcut
  # end

  # test "authorcut calculation with no group_id present" do
  #   @purchase.authorcut = ((@merchandise.price * 92.1).to_i - 30).to_f / 100 # => 1.542
  #   expected_authorcut  = 0.154e1
  #   assert_equal expected_authorcut, @purchase.authorcut
  # end

  # TODO: Test donations
  # Test authorcut
  # test 'authorcut when donation is made' do
  #   # pricesold: 20.5
  #   @purchase.authorcut = ((@purchase.pricesold * 92.1).to_i - 30).to_f / 100
  #   expected_authorcut  = 0.1858e2
  #   assert_equal expected_authorcut, @purchase.authorcut
  # end

  # test "purchaser name should not be empty or nil" do
  #   @purchaser = @user
  #   assert_not_empty @purchaser.name, "Purchaser name must not be empty"
  #   assert_not_nil @purchaser.name, "Purchaser name must not be nil"
  # end
end
