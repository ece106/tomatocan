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
    @phase = phases(:one)
    @group = groups(:one)
    assert_difference('Agreement.count',1) do
      post :create, params: { agreement: { phase_id: @phase.id, group_id: @group.id} } 
    #um, there are no records that exist in the test database with id = 1
#old syntax    post :create, agreement: { group_id: @agreement.group_id, phase_id: @agreement.phase_id }
    end
    assert_redirected_to phase_path(@phase.id)
  end




  test "should show agreement" do
    get :show, params: { id: @agreement }
    assert_response :success
  end

  test "should update agreement" do
    patch :update, id: @agreement, agreement: { group_id: @agreement.group_id, phase_id: @agreement.phase_id }
    assert_redirected_to agreement_path(assigns(:agreement))
  end

end
