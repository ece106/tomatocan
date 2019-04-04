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
    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

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

    test "test to check if the show function checks merchandise type correctly" do
      sign_in users(:one)
      purchase_demo = purchases(:one)
      get :show, params: {id: purchase_demo.id}
      refute_equal(purchase_demo.merchandise_id, nil, msg = nil)
    end

    test "user tries to purchase something from himself/herself" do 
      sign_in users(:one)
      seller = users(:one)
      merch = merchandises(:one)
      get :new, params: {pricesold: 25, author_id: seller.id, merchandise: merch}
      assert_response :success
    end 

    require 'stripe'
    #require_relative 'subscription'

    setup do
      @user = users(:two)
      @user1 = users(:one)
      sign_in @user
    end

    describe "Subscription" do
      before do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      end

    it "to test POST donation" do
      #sign_in @user
      stripe_token = Stripe:Token.create(card: {
        number: "4242424242424242",
        exp_month: 7,
        exp_year: 2100,
        cvc: "123"
      })
      post :create, params: {purchase: {user_id: @user.id, author_id: @user1.id, email: @user.email, pricesold: 5} }
      assert_response :success
    end
  end

    test "to test the POST/purchases creates purchase for the correct seller" do
      sign_in users(:two)
      @merch = merchandises(:one)
      post :create, params: {purchase: {merchandise_id: @merch.id, user_id: users(:two).id, author_id: users(:one).id, email: users(:two).email} }
      assert_equal(@purchases.author_id, users(:one).id)
    end   

end
