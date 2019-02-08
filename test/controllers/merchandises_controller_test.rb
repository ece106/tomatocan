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
      post :create, params: { merchandise: { name: 'hi', buttontype:'Buy', user_id: '7',price: '20', desc: 'Test1', itempic: 'mys', video:'Test.mp4' } }
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
  #Fails, but written correctly (controller code issue)
  test "should throw flag after failed merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 'abc', desc: 'test1', buttontype: 'one' }}
    assert_equal 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.', flash[:notice]
  end

end
