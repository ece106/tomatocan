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
    
    test "should_get_purchases_new" do
      sign_in users(:one)
      get :new, params: {merchandise_id: @purchases.merchandise_id }
      assert_response :success
    end    

    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

    test "should_create_purchases" do
      sign_in users(:one)
      assert_difference 'Purchases.count', 1 do
        post :create, params: {}
      end
    end

    # test "should_update_purchases" do
    #   sign_in users(:one)
    #   get :update, params: {id: @purchases.id}
    #   assert_response :success
    # end
end