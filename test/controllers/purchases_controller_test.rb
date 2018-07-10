require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end
  
    test "should_get_purchases_index" do
      get :index
      assert_response :success
    end
    
    test "should_get_purchases_new" do
      get :new
      assert_response :success
    end    

    test "should_get_purchases_show" do
      get :show, params: {permalink: '1dh'}
      assert_response :success
    end
    
    test "should_get_phases_edit" do
      sign_in users(:one)
      get :edit, params: {permalink: '1dh'}
      assert_response :success
    end    
end