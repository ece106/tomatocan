require 'test_helper'

class AgreementsControllerTest < ActionController::TestCase
  setup do
    @agreement = agreements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:agreements)
  end

  test "should create agreement" do
    sign_in users(:one)
    @user = users(:one)
    @group = groups(:one)
    assert_difference('Agreement.count',1) do
      post :create, params: { agreement: { user_id: @user.id, group_id: @group.id} } 
    #um, there are no records that exist in the test database with id = 1
#old syntax    post :create, agreement: { group_id: @agreement.group_id, phase_id: @agreement.phase_id }
    end
    assert_redirected_to user_path(@user.id)
  end




  test "should show agreement" do
    get :show, params: { id: @agreement }
    assert_response :success
  end

  test "should update agreement" do
    patch :update, params: { id: @agreement, agreement: { group_id: @agreement.user_id, phase_id: @agreement.user_id } }
    assert_redirected_to agreement_path(assigns(:agreement))
  end

end
