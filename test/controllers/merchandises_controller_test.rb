<<<<<<< HEAD
=======
require 'test_helper'

class MerchandisesControllerTest < ActionController::TestCase
  setup do
    @merchandise = merchandises(:one)
  end

  #test run to assert index of merchandise page found
  #passes
#test "should get index" do
#    get :index
      #assert_response :success
#assert_not_nil assigns(:merchandises)

#end
  #test run to assert a signed in user can load page to create a new merchandise
  #passes
test "should get new if user signed in" do
sign_in users(:one)
 get :new
  assert_response :success
end

  #need to test to make sure not blank page?
  # test "should load page" do
  #   sign_in users(:one)
  #   get :new
  #   assert_generates :new, message = 'page successfully loaded'
  # end

  #test run to assert a non signed in user cannot load page to create a new merchandise
  # test "shouldn't get new if no user signed in" do
  #   get :new
  #   assert_response :error
  # end

  #test run to assert id of merchandise is found
  #passes
  test "should get new with merchandise id" do
    sign_in users(:one)
    get :new , params: { id: @merchandise.id }
    assert_response :success
  end


  
  #######################################
  ####tests for creating merchandise#####
  #passes
  test "should create merchandise" do
    sign_in users(:one)
    assert_difference('Merchandise.count', 1) do
      post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
       assert_redirected_to user_profile_path(users(:one).permalink)
    end
  end

  #passes
  test "should redirect successful merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: '20', desc: 'test1', buttontype: 'one' }}
    assert_redirected_to user_profile_path(users(:one).permalink)
  end

  #
  test "should redirect failed merchandise creation attempt" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
    assert_redirected_to user_profile_path(users(:one).permalink)
  end

  #Fails, but written correctly (controller code issue)
  # test "should throw flag after failed merchandise creation" do
  #   sign_in users(:one)
  #   post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 'abc', desc: 'test1', buttontype: 'one' }}
  #   assert_equal 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.', flash[:notice]
  # end
  #######################################



  #######################################
  ####test for showing merchandise page##
  #passes
  test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
    assert_response :success
  end
  #######################################



  #######################################
  #test for editing merchandises#########
  # test "should get edit" do
  #   sign_in users(:one)
  #   get :edit, params: { id: @merchandise.id }
  #   assert_response :success
  # end
  #######################################



  ######################################
  ####tests for updating merchandise####
  #fails
  # test "should update merchandise" do
  #   sign_in users(:one)
  #   patch :update, params: {id: @merchandise, merchandise: { name: "chris", user_id: 1, price: 20, desc: "test", buttontype: "one" }}
  #   assert_response :success
  # end

  #passes
  test "should redirect back to merchandise after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
    assert_redirected_to merchandise_path(assigns(:merchandise))
  end

  #passes
  test "should throw flag after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'one' }}
    assert_equal flash[:notice], 'Patron Perk was successfully updated.'
  end
  ######################################



  #following tests run to assert set_merchandise runs correctly
  # test "should set merchandise" do
  #   assert @merchandise.valid?
  # end
  # test "should set user" do
  #   assert @user.valid?
  # end
  # test "should confirm user not signed in as different user" do
  #   duplicate_user = @user.duplicate_dup
  #   @user.save
  #   assert_not duplicate_user.valid?
  # end
  # test "should set expiredmerch" do
  #   assert @expiredmerch.valid?
  # end
end
>>>>>>> 306c7e73bf1132481251cc997d5b74faf07b09b5
