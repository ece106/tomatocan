require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end

    test "should_get_purchases_new_purchase" do
      @merchandises = merchandises(:one)
      sign_in users(:two)
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


    test "should get new purchase with stripe" do
      sign_in users(:one)
      seller = users(:two)
      get :new, params: { pricesold: 25, author_id: seller.id, stripe_customer_token: 'prachi' }
      
      assert_response :success
    end

    #test to check the address for non-downloadable/physical purchases
    test "should test for absent address for non-downloadable physical purchases" do
      sign_in users(:one)
      seller = users(:two)
      get :new, params: { pricesold: 25, author_id: seller.id, merchandise: { name: seller.name, price: '20', desc: 'carrots', buttontype: 'buy' }, shipaddress: nil}
      assert_response :error
    end

    test "should test for present address for non-downloadable physical purchases" do
      sign_in users(:one)
      seller = users(:two)
      get :new, params: { pricesold: 25, author_id: seller.id, merchandise: { name: seller.name, price: '20', desc: 'carrots', buttontype: 'buy' }, shipaddress: "earth"}
      assert_response :success
    end

end
