require 'test_helper'

class PhasesControllerTest < ActionController::TestCase
  setup do
    @phases = phases(:one)
  end
  
    test "should_get_phases_index" do
      get :index
      assert_response :success
    end
    
    
    
    
=begin    
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
=end
end
