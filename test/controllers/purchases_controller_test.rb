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
  require 'stripe_mock'
setup do
  @user = users(:one)
  @email= @user.email
end
  describe "MyApp" do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it "test to create a strip account for seller" do
      seller1 = Stripe::Customer.create({
        email: @email,
        source: stripe_helper.generate_card_token
    })
    assert_equal(seller1.email, @email)
    end
  end

  #11
    test "user tries to purchase something from himself/herself" do #is response 200 OK but should give an error
      sign_in users(:one)
      seller = users(:one)
      merch = merchandises(:one)
      get :new, params: {pricesold: 25, author_id: seller.id, merchandise: merch}
      assert_response :success
    end 

  #12
    test "create a new audio purchase" do
      sign_in users(:one)
      post :create, params: { purchase: {merchandise_id: merchandises(:one)}}
      assert_equal(pricesold, merchandises(:one).price)
    end
  

  #13
    test "to test the flash message displayed after the purchase goes through" do

    end

  #14
    test "to test the flash message displayed after the purchase does not go through" do

    end


end