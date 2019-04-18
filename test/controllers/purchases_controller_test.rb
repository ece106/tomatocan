require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) #user 2 is the customer 
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

# I will continue working on the tests below after my finals so please don't delete them. 

    # test "to create a customer and card" do
    #   sign_in @purchaser
    #   card = { :number => "4242424242424242", :exp_month => 8, :exp_year => 2060, :cvc => "123"}
    #   response = Stripe::Token.create(:card => card)
    #   puts response['id'] #stripe_card_token
    #   #tok_Err6MO4xam1YkA = stripe-card-token generated
    #   customer = Stripe::Customer.create(
    #                                     :source => response['id'],
    #                                     :description => @purchaser.name,
    #                                     :email => @purchaser.email
    #                                     )
    #   puts customer
    #   @purchaser.stripe_customer_token = customer.id
    #   puts "helooooooo"
    #   puts @purchaser.stripe_customer_token
    #   puts users(:two).stripe_customer_token
    #   puts @purchaser.id
    #   puts "byeeeeeeee"
    #   post :create, params: {purchase: {user_id: @purchaser.id, author_id: users(:one).id, stripe_customer_token: @purchaser.stripe_customer_token, pricesold: 10} }

    #   assert_response :success
    # end 


    # test "to test the POST/purchases creates purchase for the correct seller" do
    #   sign_in users(:two)
    #   @merch = merchandises(:one)
    #   post :create, params: {purchase: {merchandise_id: @merch.id, user_id: users(:two).id, author_id: users(:one).id, email: users(:two).email} }
    #   assert_equal(@purchases.author_id, users(:one).id)
    # end   

end
