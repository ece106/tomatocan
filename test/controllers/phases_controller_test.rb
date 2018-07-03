require 'test_helper'

  class PhasesControllerTest < ActionController::TestCase
  setup do
    @phases = phases(:one)
  end
  
    test "should_get_phases_index" do
      get :index
      assert_response :success
    end
    
    test "should_get_phases_new" do
      get :new
      assert_response :success
    end    

    test "should_get_phases_show" do
      get :show
      assert_response :success
    end
    
    test "should_get_phases_storytellerperks" do
      sign_in users(:one)
      get :storytellerperks
      assert_response :success
    end
    
=begin
    test "should_get_phases_edit" do
      sign_in users(:one)
      @merchandise = merchandises(:one)
      get :show, params: {permalink: '1dh'}
      assert_response :success
    end    
#=begin      
    #test whether has merchandise, if not route to storytellerperks to add something to campaign
    #test by making users with and without merchandise (and with and without campaigns)

    test "should_get_phases_edit" do
      #@user = users(:one)
      sign_in users(:one)
      get :show, params: {permalink: '1dh'}
      assert_response :success
    end    
    test "should_get_phases_edit" do
      #@user = users(:one)
      sign_in users(:one)
      get :show, params: {permalink: '1dh'}
      assert_response :success
    end

    test "should_get_phases_edit" do
      get :edit, params: {permalink: 'onedayinhell'}
      assert_response :success
    end
      
    test "should_get_phases_new" do
      get :new
      assert_response :success
    end
      
    test "should_get_phases_patronperk" do
      get :patronperk
      assert_response :success
    end
      
    test "should_get_phases_show" do
      get :show
      assert_response :success
    end
      
    test "should_get_phases_storytellerperks" do
      get :storytellerperks
      assert_response :success
    end
=end
  end