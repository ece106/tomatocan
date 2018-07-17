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

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create agreement" do
    assert_difference('Agreement.count') do
#     post :create, params: { agreement: {phase: one, group: two} }
#     post :create, params: { agreement: { phase_id: @agreement.phase_id, group_id: @agreement.group_id } }
      post :create, params: { agreement: { phase_id: 1, group_id: 1 } }
    end
    assert_redirected_to agreement_path(assigns(:agreement).id)
  end
  
=begin
  test "should show agreement" do
    get :show, params: { id: @agreement }
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @agreement
    assert_response :success
  end

  test "should update agreement" do
    patch :update, id: @agreement, agreement: { group_id: @agreement.group_id, phase_id: @agreement.phase_id }
    assert_redirected_to agreement_path(assigns(:agreement))
  end

  test "should destroy agreement" do
    assert_difference('Agreement.count', -1) do
      delete :destroy, id: @agreement
    end

    assert_redirected_to agreements_path
  end
=end
end
