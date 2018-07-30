require 'test_helper'

class PhasesControllerTest < ActionController::TestCase
  setup do
    @phases = phases(:one)
  end
  
    test "should_get_phases_index" do
      get :index
      assert_response :success
    end

    test "should_get_phases_index_user_signed_in" do
      sign_in users(:one)
      get:index, params: {id: @phases.id }
      assert_response :success
    end

    test "if_stripeid_is_null" do
      perm = Phase.first.permalink
      get :index, params: {permalink: perm}
      assert_response :success
    end
    
     test "if_stripeid_is_not_null_user_signed_in" do
      sign_in users(:one)
      perm = Phase.first.permalink
      get :index, params: {permalink: perm}
      assert_response :success
    end

    test "should_get_phases_new" do
      get :new
      assert_response :success
    end  
 
    test "should_get_phases_show" do
      perm = Phase.first.permalink
      get :show, params: {permalink: perm}
      assert_response :success
    end
    
    test "should_get_phases_show_id" do
      get :show, params: {id: @phases.id }
      assert_response :success
    end


   test "should_show_perk_only_when_user_logged_in" do
    sign_in users(:one)
    perm = Phase.first.permalink
    get :patronperk, params: { permalink: perm}
    assert_response :success ," The user is logged in"
   end

  test "show_get_phases_show_page" do
    get :show,params: {permalink: '1dh'}
    assert_response :success
  end

    test "should_get_phases_storytellerperks" do
      sign_in users(:one)
      get :storytellerperks, params: {permalink: '1dh'}
      assert_response :success
    end

    
    test "should_get_phases_edit" do
      sign_in users(:one)
      get :edit, params: {permalink: '1dh'}
      assert_response :success
    end   

    test "shoule_create_phase_if_user_logged_in" do
      sign_in users(:one)
      assert_difference('Phase.count', 1) do
        post :create, params: { phase: { name: 'samiam', user_id: '2',
            mission: 'secret12', phasepic: 'ps_2.jpg', permalink: 'samlink' } }
        end
       assert_redirected_to phase_storytellerperks_path(assigns(:phase).permalink)
    end


test "should_update_phases_when_user_logged_in" do
    sign_in users(:one)
    patch :update, params: { id: @phases.id, phase: { name: 'New Name' } }
    phase = Phase.find_by_permalink(@phase.permalink)
    assert_equal(phase.name, "New Name") 
    assert_redirected_to @phase
  end

end