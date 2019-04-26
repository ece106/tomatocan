require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
    # test "should get home" do
    #  get :home
    #  assert_response :success
    #end

  test "should_get_aboutus" do
    get :aboutus
    assert_response :success
  end
  
  test "should_get_faq" do
    get :faq
    assert_response :success
  end
  
  test "should_get_suggestedperks" do
    get :suggestedperks
    assert_response :success
  end  
  
  test "should_get_tellfriends" do
    get :tellfriends
    assert_response :success
  end  
  
  test "should_get_tos" do
    get :tos
    assert_response :success
  end

#test "correct_head" do
  #get :home
	#assert_select 'title', "CrowdPublish.TV"
 #end


end
