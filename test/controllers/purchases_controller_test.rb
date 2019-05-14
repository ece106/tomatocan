require 'test_helper'
require 'stripe'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) #user 2 is the customer 
    @seller = users(:one)
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

    test "to create a donation for customer who is registered with Stripe and whose email is posted" do
      puts "test 1"
      sign_in @purchaser
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      puts cardToken['id'] #stripe_card_token
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      post :create, params: {purchase: {user_id: @purchaser.id, email: @purchaser.email, author_id: @seller.id, stripe_customer_token: @purchaser.stripe_customer_token,stripe_card_token: cardToken['id'], pricesold: 10} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 
 

    test "to create a donation for customer who is registered with Stripe but whose email is not posted" do
      puts "test 2"
      sign_in @purchaser
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      post :create, params: {purchase: {user_id: @purchaser.id, author_id: @seller.id, stripe_customer_token: @purchaser.stripe_customer_token, stripe_card_token: cardToken['id'], pricesold: 10} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 

    test "to create a donation for customer who is not registered with Stripe" do
      puts "test 3"
      sign_in @purchaser
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      post :create, params: {purchase: {user_id: @purchaser.id, author_id: @seller.id, stripe_card_token: cardToken['id'], pricesold: 10} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 

    test "to create a merchandise purchase for merchandise(:one) when the purchaser is signed in, email is posted and is registered with Stripe" do
      puts "test 4"
      sign_in @purchaser
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      post :create, params: {purchase: {email: @purchaser.email, merchandise_id: merchandises(:one), user_id: @purchaser.id, author_id: @seller.id, stripe_customer_token: @purchaser.stripe_customer_token,stripe_card_token: cardToken['id'], pricesold: 1.5} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 

    test "to create a merchandise purchase for merchandise(:one) when purchaser is not signed in but has email posted and is registered with Stripe" do
      puts "test 5"
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      post :create, params: {purchase: {email: @purchaser.email, merchandise_id: merchandises(:one), user_id: @purchaser.id, author_id: @seller.id, stripe_customer_token: @purchaser.stripe_customer_token,stripe_card_token: cardToken['id'], pricesold: 1.5} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 

    test "to create a merchandise purchase for merchandise(:one) when purchaser is not signed in, has no email address posted and is not registered with Stripe" do
      puts "test 6"
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      post :create, params: {purchase: {merchandise_id: merchandises(:one), user_id: @purchaser.id, author_id: @seller.id, stripe_card_token: cardToken['id'], pricesold: 1.5} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end

    test "to create a merchandise purchase for merchandise(:one) when seller has id 143 " do
      puts "test 7"
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create(
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @merch = merchandises(:one)
      @merch.update_column(:user_id, 143)
      @purchaser.update_column(:stripe_customer_token, customer.id)
      @seller.update_column(:id, 143)
      post :create, params: {purchase: {email: @purchaser.email, merchandise_id: merchandises(:one), user_id: @purchaser.id, author_id: @seller.id, stripe_customer_token: @purchaser.stripe_customer_token,stripe_card_token: cardToken['id'], pricesold: 1.5} }
      assert_redirected_to user_profile_path(users(:one).permalink)
    end 

end
