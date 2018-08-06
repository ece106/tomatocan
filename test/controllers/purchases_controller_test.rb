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
      perm = Phase.first.permalink
      get :new , params: {permalink: perm}
      assert_response :success
    end    

    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end
end