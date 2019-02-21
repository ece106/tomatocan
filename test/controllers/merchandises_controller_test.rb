require 'test_helper'

class MerchandisesControllerTest < ActionController::TestCase
  setup do
    @merchandise = merchandises(:one)
  end
  
  test "should get index" do
    get :index
    assert_response :success
    #assert_not_nil assigns(:merchandises)
  end

  test "should get new if user signed in" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  # test "shouldn't get new if no user signed in" do
  #   get :new
  #   assert_response :error
  # end

  test "shouldn't be able to access another user's merchandise" do
    get :edit, params: { id: @merchandise.id }
    assert_response :error
  end

  test "should get new with merchandise id" do
    sign_in users(:one)
    get :new , params: { id: @merchandise.id }
    assert_response :success
  end

  #######################################
  ####test for showing merchandise page##
  
  test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
    assert_response :success
  end
  #######################################

  



  #######################################
  #### tests for create merchandise #####

  test "should create merchandise" do
    sign_in users(:one)
    assert_difference('Merchandise.count', 1) do
      post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
       assert_redirected_to user_profile_path(users(:one).permalink)
    end
  end

  test "should redirect successful merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: '20', desc: 'test1', buttontype: 'one' }}
    assert_redirected_to user_profile_path(users(:one).permalink)
  end


  # test "shouldn't save mercahndise if required fields incomplete" do
  #   merchandise = Merchandise.new
  #   merchandise.name = 'chris'
  #   merchandise.user_id = '1'
  #   merchandise.desc = 'test1'
  #   merchandise.buttontype = 'one'
  #   assert !merchandise.valid?
  #   assert !merchandise.save
  #   assert_redirected_to :edit
  # end

  test "should throw flag after successful merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: '20', desc: 'test1', buttontype: 'one' }}
    assert_equal 'Patron Perk was successfully created.', flash[:notice]
  end

  # test "should redirect failed merchandise creation attempt" do
  #   sign_in users(:one)
  #   post :create, params: { merchandise: { name: 'chris', user_id: 1, desc: 'test', buttontype: 'Buy' }}
  #   assert_redirected_to :edit
  # end

  # test "should throw flag after failed merchandise creation" do
  #   sign_in users(:one)
  #   post :create, params: { merchandise: { name: 'chris', user_id: 1, desc: 'test1', buttontype: 'one' }}
  #   assert_equal 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.', flash[:notice]
  # end
  #######################################





  #######################################
  ### test for editing merchandises #####

  test "should get edit" do
    sign_in users(:one)
    get :edit, params: { id: @merchandise.id }
    assert_response :success
  end


  ######################################
  ### tests for updating merchandise ###

  test "should redirect back to merchandise after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
    assert_redirected_to merchandise_path(assigns(:merchandise))
  end

  test "should throw flag after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'one' }}
    assert_equal flash[:notice], 'Patron Perk was successfully updated.'
  end

  # test "should redirect failed update attempt" do
  #   sign_in users(:one)
  #   patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'one' }}
  #   assert_template :edit
  # end
  ######################################



  #following tests run to assert set_merchandise runs correctly
  test "should set merchandise" do
    assert @merchandise.valid?
  end

  test "should set user" do
    @user = User.find(@merchandise.user_id)
    assert @user.valid?
  end

  # test "should confirm user not signed in as different user" do
  #   duplicate_user = @user.duplicate_dup
  #   @user.save
  #   assert_not duplicate_user.valid?
  # end

  # test "should set expiredmerch" do
  #   assert @expiredmerch.valid?
  # end

  

  #######################################
  ##### tests for page layouts ##########

  test "should render correct layout for show" do
    get :show, params: { id: @merchandise.id }
    assert_template 'userpgtemplate'
  end

  test "should render correct layout for edit" do
    sign_in users(:one)
    get :edit, params: { id: @merchandise.id }
    assert_template 'userpgtemplate'
  end

  test "should render correct layout for index" do
    get :index
    assert_template 'application'
  end

  test "should render correct layout for new" do
    get :new
    assert_template 'application'
  end
  #######################################

end
