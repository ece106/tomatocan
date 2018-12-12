require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchases = purchases(:one)
  end
  
    test "should_get_purchases_index" do
      sign_in users(:one)
      get :index
      assert_response :success
    end
    
    test "should_get_purchases_new" do
      sign_in users(:one)
      get :new, params: {merchandise_id: @purchases.merchandise_id }
      assert_response :success
    end    

    test "should_get_purchases_show" do
      sign_in users(:one)
      get :show, params: {id: @purchases.id }
      assert_response :success
    end

    # test "should_edit_purchases" do
    #   sign_in users(:one)
    #   get :edit, params: {id: @purchases.id}
    #   assert_response :success
    # end

    test "should_create_purchase" do
      sign_in users(:one)
      assert_difference 'Purchases.count' do
        post :create, params: { purchase: { stripe_customer_token: @purchases.stripe_customer_token, bookfiletype: @purchases.bookfiletype, 
          groupcut: @purchases.groupcut, shipaddress: @purchases.shipaddress, book_id: @purchases.book_id, 
          stripe_card_token: @purchases.stripe_card_token, user_id: @purchases.user_id, author_id: @purchases.author_id, 
          merchandise_id: @purchases.merchandise_id, group_id: @purchases.group_id, email: @purchases.email} }
      end
    end
end