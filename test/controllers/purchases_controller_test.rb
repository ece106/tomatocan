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
      sign_in users(:two)
      seller = users(:one)
      merch = merchandises(:two)
      get :new, params: { pricesold: 25, author_id: seller.id, merchandise: merch }
      assert_response :success
    end

    # test "should get new donate" do
    #   sign_in users(:one)
    #   merch = merchandises(:two)
    #   get :new, params: {pricesold: 25, merchandise: merch}
    #   assert_equal(merch.id, nil, msg = nil)
    # end

    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

    #show 2/19/19
    test "test user should get correct seller for purchased merchandise" do
       sign_in users(:one)
       purchase_demo = purchases(:one)
       get :show, params: {id: purchase_demo.id}
       assert_equal(purchase_demo.merchandise.user_id, 2, msg = nil)
    end 

    test "test user should get correct button type for the purchase" do
       sign_in users(:one)
       purchase_demo = purchases(:one)
       get :show, params: {id: purchase_demo.id}
       assert_equal(purchase_demo.merchandise.buttontype, "Donate", msg = nil)
    end 

    test "test user should get correct merchandise price for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.merchandise.price, 1.5, msg = nil)
    end 

    test "test user should get correct pricesold for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.pricesold, 50.5, msg = nil)
    end 

    test "test user should get correct authorcut for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.authorcut, 38.1, msg = nil)
    end 

end
