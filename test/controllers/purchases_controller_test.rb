

require 'test_helper'
require 'stripe'

class PurchasesControllerTest < ActionController::TestCase

	 include ActiveJob::TestHelper

  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) # user 2 is the customer
    @seller = users(:one)
    @token = Stripe::Token.create(card: { number: '4242424242424242',
                                          exp_month: 8, exp_year: 2050,
                                          cvc: 132})
    @purchase_info ={ user_id: @purchaser.id,
                      author_id: users(:one).id,
                      stripe_customer_token: @purchaser.stripe_customer_token,
                      stripe_card_token: @token.id,
                      pricesold: 10 }
    @customer = Stripe::Customer.create(description: @purchaser.name,
                                        email: @purchaser.email)
    @merchandise = merchandises(:one)
    @donation_merchandise = merchandises(:seven)
  end

  test 'should_get_purchases_new_purchase' do
    @merchandises = merchandises(:one)
    sign_in users(:two)
    get :new, params: { merchandise_id: @merchandises.id }
    assert_response :success
  end

  test 'should_get_purchases_new_donate' do
    sign_in users(:two)
    seller = users(:one)
    merch = merchandises(:two)
    get :new, params: { pricesold: 25, author_id: seller.id, merchandise: merch }
    assert_response :success
  end

  test 'should_get_purchases_show' do
    sign_in users(:one)
    get :show, params: { id: @purchases.id }
    assert_response :success
  end

  test 'user tries to purchase something from himself/herself' do
    sign_in users(:one)
    seller = users(:one)
    merch = merchandises(:one)
    get :new, params: { pricesold: 25, author_id: seller.id, merchandise: merch }
    assert_response :success
  end

  test 'purchase with merchandise sends mail' do
    @purchase_info[:merchandise_id] = merchandises(:one).id
    post :create, params: { purchase: @purchase_info }
    assert_enqueued_jobs(2)
    assert_equal "You have successfully completed the purchase! Thank you for being a patron of #{@seller.name}",
      flash[:success]
    assert_redirected_to user_profile_path(@seller.permalink)
    # There should be 2 emails in the box one for each seller one for buyer
  end

  test 'successful donation' do
    sign_in @purchaser
    @purchase_info[:merchandise_id] = @donation_merchandise.id
    post :create, params: { purchase: @purchase_info }
    assert_enqueued_jobs 2
    assert_equal "You successfully donated $#{@donation_merchandise.price.to_s} . Thank you for being a donor of #{@seller.name}",
      flash[:notice]
    assert_redirected_to user_profile_path(@seller.permalink)
  end

end
