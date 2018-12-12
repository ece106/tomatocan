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


  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  test 'should get new with merchandise id' do
    sign_in users(:one)
    get :new , params: { id: @merchandise.id }
    assert_response :success
  end

  test "should_create_merchandise" do
      sign_in users(:one)
      assert_difference('Merchandise.count',1) do
      post :create, params: { merchandise: { desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3' }}
    end
    #assert_redirected_to phase_storytellerperks_path(assigns(:merchandise))
  end

  test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
    assert_response :success
  end

  test "should get edit" do
     sign_in users(:one)
     get :edit, params: { id: @merchandise.id }
    assert_response :success
  end

  test "should update merchandise" do
    sign_in users(:one)
    patch :update, params: { id: @merchandise, merchandise: { desc: 'Test1', itempic: 'mys', name: 'hi', price: '20', user_id: '3' } }
    #assert_redirected_to merchandise_path(assigns(:merchandise))
    assert_response :success
  end

end
