require 'test_helper'

class MerchandisesControllerTest < ActionController::TestCase
  setup do
    @merchandise = merchandises(:one)
  end

  #test run to assert index of merchandise page found
  test "should get index" do
    get :index
    assert_response :success
    #assert_not_nil assigns(:merchandises)
  end

  #test run to assert a signed in user can load page to create a new merchandise
  test "should get new if user signed in" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  #need to test to make sure not blank page?
  test "should load page" do
    get :new
    assert_generates :new, message = 'page successfully loaded'
  end

  #test run to assert a non signed in user cannot load page to create a new merchandise
  test "shouldn't get new if no user signed in" do
    get :new
    assert_response :error
  end

  #test run to assert id of merchandise is found?
  test 'should get new with merchandise id' do
    sign_in users(:one)
    get :new , params: { id: @merchandise.id }
    assert_response :success
  end

  #tests run to assert that a user can create a new merchandise and then the page is redirected to that users perks page
  test "should create merchandise" do
      sign_in users(:one)
      assert_difference('Merchandise.count',1) do
        post :create, params: { merchandise: { desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
      end
  end

  test "should redirect successful merchandise creation" do
    sign_in users(:one)
    post 
  end

  #test run to assert that if a merchandise is not saved, it redirects to new merch page and displays flag
  test "should redirect failed merchandise creation attempt" do
    sign_in users(:one)
    post :create, params: { merchandise: { desc: '', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
    assert_redirected_to controller: "merchandises", action: "new"
    #assert_redirected_to phase_storytellerperks_path(assigns(:merchandise))
  end

  test "should throw flag after failed merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { desc: '', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
    assert_equal 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.', flash[:notice]
  end

  #test run to assert that an non signed in user shouldn't be able to create new merchandise
  test "shouldn't create merchandise" do
    assert_difference('Merchandise.count', 0) do
      post :create, params: { merchandise: { desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
    end
  end

  #test run to assert users page of merchandise loads
  test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
    assert_response :success
  end

  #test run to assert that user can edit the merchandise posted
  test "should get edit" do
    sign_in users(:one)
    get :edit, params: { id: @merchandise.id }
    assert_response :success
  end

  #test run to assert that a user can update their perks and then be redirected to their merchandise page
  test "should update merchandise" do
    sign_in users(:one)
    patch :update, params: { id: @merchandise, merchandise: { desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
    assert_response :success
  end

  test "should redirect back to merchandise after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: {desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3'}}
    assert_redirected_to merchandise_path(assigns(:merchandise))
  end

  test "should throw flag after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: {desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3'}}
    assert_same flash(:notice), 'Patron Perk was successfully updated'
  end

  #following tests run to assert set_merchandise runs correctly
  test "should set merchandise" do
    assert @merchandise.valid?
  end
  test "should set user" do
    assert @user.valid?
  end
  test "should confirm user not signed in as different user" do
    duplicate_user = @user.duplicate_dup
    @user.save
    assert_not duplicate_user.valid?
  end
  test "should set expiredmerch" do
    assert @expiredmerch.valid?
  end
end
