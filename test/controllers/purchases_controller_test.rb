require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end

    test "should_get_purchases_new_purchase" do
      @merchandises = merchandises(:one)
      sign_in users(:one)
      get :new, params: { merchandise_id: @merchandises.id }
      assert_response :success
    end

    test "should_get_purchases_new_donate" do
      sign_in users(:one)
      seller = users(:two)
      get :new, params: { pricesold: 25, author_id: seller.id }
      assert_response :success
    end
    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

    # test "should_create_new_purchase" do
    #   sign_in users(:one)
    #   post :create, params: {}
    # end  

#test "mocks a declined card error" do
    # Prepares an error for the next create charge request
#     StripeMock.start
#    StripeMock.prepare_card_error(:card_declined)
#    assert_raise(Stripe::Charge.create(amount: 1, currency: 'usd')) {|e|
#    assert_throws :Stripe::CardError
#   assert_equal(e.http_status, 402)
#  assert_equal(e.code, 'card_declined')}
#  StripeMock.stop

#end
end
