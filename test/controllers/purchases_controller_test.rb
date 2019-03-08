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
  require 'stripe_mock'

  describe "MyApp" do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }

    it "test to create a strip account for seller" do
      seller1 = Stripe::Customer.create({
        email: 'fake@fake.com',
        source: stripe_helper.generate_card_token
    })
    assert_equal(seller1.email,'fake@fake.com')
    end
  end

  describe "create customer" do
    def stripe_helper
      StripeMock.create_test_helper
    end

    before do
      StripeMock.start
    end

    after do
      StripeMock.stop
    end

    test "creates a stripe customer" do
      customer = Stripe::Customer.create({
                                         email: "koko@koko.com",
                                         card: stripe_helper.generate_card_token
                                     })
      assert_equal customer.email, "koko@koko.com"
    end
  end

  #11
    test "user tries to purchase something from himself/herself" do
      sign_in users(:one)

    end

  #12
    test "to test the flash message displayed after the purchase goes through" do

    end

  #13
  test "to test the flash message displayed after the purchase does not go through" do

  end


end