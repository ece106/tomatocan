

require 'test_helper'
require 'stripe'

class PurchasesControllerTest < ActionController::TestCase

  include ActionMailer::TestHelper

  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) # user 2 is the customer
    @seller = users(:one)
    @token = Stripe::Token.create(card: { number: '4242424242424242',
                                          exp_month: 8, exp_year: 2025,
                                          cvc: 132})
    @purchases.stripe_customer_token = @purchaser.stripe_customer_token
    @purchases.stripe_card_token = @token.id

    @customer = Stripe::Customer.create(description: @purchaser.name,
                                        email: @purchaser.email)
    @merchandise = merchandises(:one)
    @donation_merchandise = merchandises(:seven)

    @default_donation = purchases(:donation_no_merchandise)
    @default_donation.stripe_card_token = @token.id
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

  test 'Default donation' do
    seller = User.find(@default_donation.author_id)
    post :create, params: { purchase: @default_donation.attributes}
    assert_enqueued_emails 2
    assert_equal "You successfully donated $#{@default_donation.pricesold} . Thank you for being a donor of #{seller.name}",
      flash[:notice]
    assert_redirected_to user_profile_path(seller.permalink)
  end

  test 'Merchandise purchase' do
    @purchases.merchandise_id = merchandises(:one).id
    post :create, params: { purchase: @purchases.attributes }
    assert_enqueued_emails 2
    assert_equal "You have successfully completed the purchase! Thank you for being a patron of #{@seller.name}",
      flash[:success]
    assert_redirected_to user_profile_path(@seller.permalink)
  end

  test 'Merchandise donation' do
    sign_in @purchaser
    @purchases.merchandise_id = @donation_merchandise.id
    post :create, params: { purchase: @purchases.attributes }
    assert_enqueued_emails 2
    assert_equal "You successfully donated $#{@donation_merchandise.price} . Thank you for being a donor of #{@seller.name}",
      flash[:notice]
    assert_redirected_to user_profile_path(@seller.permalink)
  end
end
