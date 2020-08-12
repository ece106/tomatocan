require 'test_helper'

class MerchandisesControllerTest < ActionController::TestCase
  setup do
    @merchandise = merchandises(:one)
  end

  test "should get index" do
    get :index
      assert_response :success
  end

  test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
      assert_response :success
  end

  test "should get new if user signed in" do
    sign_in users(:confirmedUser)
      get :new
      assert_response :success
  end

  test "should get new with merchandise id" do
    sign_in users(:confirmedUser)
      get :new , params: { id: @merchandise.id }
      assert_response :success
  end

  test "should get edit" do
    sign_in users(:confirmedUser)
      get :edit, params: { id: @merchandise.id }
      assert_response :success
  end

  test "should create 1 merchandise" do
    sign_in users(:confirmedUser)
      assert_difference('Merchandise.count', 1) do
        post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
      end
  end

  test "should create 2 merchandises" do
    sign_in users(:confirmedUser)
      assert_difference('Merchandise.count', 2) do
        post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
          post :create, params: { merchandise: { name: 'rob', user_id: 1, price: '20', desc: 'test1', buttontype: 'Buy' }}
      end
  end

  test "should create 1 merchandise for failed create" do
    sign_in users(:confirmedUser)
      assert_difference('Merchandise.count', 1) do
        post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
          post :create, params: { merchandise: { name: '', user_id: 1, price: '20', desc: 'test1', buttontype: 'Buy' }}
      end
  end

  test "should redirect successful merchandise creation" do
    sign_in users(:confirmedUser)
      post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
      assert_redirected_to user_profile_path(users(:confirmedUser).permalink)
  end

  test "should throw flag after successful merchandise creation" do
    sign_in users(:confirmedUser)
      post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
      assert_equal 'Patron Perk was successfully created.', flash[:notice]
  end

  test "should throw flag for no price" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', desc: 'test1', buttontype: 'one' }}
    assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
  end


  test "should throw flag for inputting letters into price" do
    sign_in users(:confirmedUser)
    post :create, params: {merchandise: {name: 'chris', user_id: '1', price: '1g3', desc: 'test1', buttontype: 'Buy'}}
    assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.' 
  end


  test "should throw flag for no price and no name" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { user_id: '1', desc: 'test1', buttontype: 'one' }}
    assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
  end

  test "should throw flag for no name" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { price: '20', user_id: '1', desc: 'test1', buttontype: 'one' }}
    assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
  end

  test "should redirect failed merchandise creation attempt for no price" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { name: 'chris', user_id: 1, desc: 'test', buttontype: 'Buy' }}
    assert_template :new
  end

  test "should redirect failed merchandise creation attempt for letters inputted into price" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: 'hello', desc: 'test', buttontype: 'Buy' }}
    assert_template :new
  end

  test "should redirect failed merchandise creation attempt for no name" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { price: '20', user_id: '1', desc: 'test', buttontype: 'Buy' }}
    assert_template :new
  end

  test "should redirect failed merchandise creation attempt for no price and no name" do
    sign_in users(:confirmedUser)
    post :create, params: { merchandise: { user_id: 1, desc: 'test', buttontype: 'Buy' }}
    assert_template :new
  end

  test "should redirect back to merchandise after merchandise updated" do
    sign_in users(:confirmedUser)
      patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
      assert_redirected_to merchandise_path(assigns(:merchandise))
  end

  test "should throw flag after merchandise updated" do
    sign_in users(:confirmedUser)
      patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test1', buttontype: 'Buy' }}
      assert_equal flash[:notice], 'Patron Perk was successfully updated.'
  end

  test "should redirect failed update attempt with no name" do
    sign_in users(:confirmedUser)
    patch :update, params: {id: @merchandise, merchandise: {name: '', user_id: '1', price: '1', desc: 'test', buttontype: 'Buy'}}
    assert_template :edit
  end

  test "should redirect failed update attempt with no price" do
    sign_in users(:confirmedUser)
    patch :update, params: {id: @merchandise, merchandise: {name: 'rob', user_id: '1', price: '', desc: 'test', buttontype: 'Buy'}}
    assert_template :edit
  end

  test "should redirect failed update attempt for inputting letters into price" do
    sign_in users(:confirmedUser)
    patch :update, params: {id: @merchandise, merchandise: {name: 'rob', user_id: '1', price: 'one', desc: 'test', buttontype: 'Buy'}}
    assert_template :edit
  end

  test "should redirect failed update attempt" do
    sign_in users(:confirmedUser)
    patch :update, params: {id: @merchandise, merchandise: { name: '', user_id: '', price: '', desc: '', buttontype: ''}}
    assert_template :edit
  end

  test "should check for changes in database when update" do
  	sign_in users(:confirmedUser)
	  assert_difference('Merchandise.count', 1) do
        post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}
	    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test2', buttontype: 'Buy' }}
      end
  end

  test "should return correct layout id" do
    sign_in users(:confirmedUser)
      post :create, params: { merchandise: { name: 'chris', user_id: 1, price: '20', desc: 'test', buttontype: 'Buy' }}    
      patch :update, params: {id: @merchandise, merchandise: {name: '', user_id: '1', price: '1', desc: 'test', buttontype: 'Buy'}}
      assert_template layout:'application'
      post :create, params: { merchandise: { price: '20', user_id: '1', desc: 'test1', buttontype: 'one' }}
      assert_template layout: 'application'
  end
end
