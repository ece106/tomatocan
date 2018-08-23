require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
    def setup
    @purchase = purchases(:one)
  end
  # end


  [:user_id, :author_id, :pricesold, :authorcut ].each do |field|
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
  	purchase.send "merchandise_id=",nil
  	refute purchase.valid? #book_id and merchandise_id must not be nil
  end
end
