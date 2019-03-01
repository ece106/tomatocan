require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end

  #1
    test "should_get_purchases_new_purchase" do
      @merchandises = merchandises(:one)
      sign_in users(:two)
      get :new, params: { merchandise_id: @merchandises.id }
      assert_response :success
    end

  #2
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

  #3
    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

  #4
    test "test user should get correct seller for purchased merchandise" do
       sign_in users(:one)
       purchase_demo = purchases(:one)
       get :show, params: {id: purchase_demo.id}
       assert_equal(purchase_demo.merchandise.user_id, 2, msg = nil)
    end 

  #5
    test "test user should get correct button type for the purchase" do
       sign_in users(:one)
       purchase_demo = purchases(:one)
       get :show, params: {id: purchase_demo.id}
       assert_equal(purchase_demo.merchandise.buttontype, "Donate", msg = nil)
    end 

  #6
    test "test user should get correct merchandise price for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.merchandise.price, 1.5, msg = nil)
    end 

  #7
    test "test user should get correct pricesold for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.pricesold, 50.5, msg = nil)
    end 

  #8
    test "test user should get correct authorcut for the purchase" do
      sign_in users(:one)
      purchase_demo = purchases(:two)
      get :show, params: {id: purchase_demo.id}
      assert_equal(purchase_demo.authorcut, 38.1, msg = nil)
    end

  #9
    test "test to check if the show function checks merchandise type correctly" do
      sign_in users(:one)
      purchase_demo = purchases(:one)
      get :show, params: {id: purchase_demo.id}
      refute_equal(purchase_demo.merchandise_id, nil, msg = nil)
    end


  #10
    test "user tries to purchase something without signing in" do
      @merchandises = merchandises(:one)
      get :new, params: { merchandise_id: @merchandises.id }
      assert_redirected_to 
    end

  #11
    test "user tries to make a purchase without setting up stripe account" do

    end

  #12
    test "user tries to purchase something from himself/herself" do

    end


end
