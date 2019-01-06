require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end
  
    test "should_get_purchases_index" do
      sign_in users(:one)
      get :index
      assert_response :success
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
    
end