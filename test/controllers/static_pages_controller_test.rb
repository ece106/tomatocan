require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get aboutus" do
    get :aboutus
    assert_response :success
  end
  
  test "should get aboutusold" do
    get :aboutusold
    assert_response :success
  end 
  
  test "should get faq" do
    get :faq
    assert_response :success
  end
  
  test "should get suggestedperks" do
    get :suggestedperks
    assert_response :success
  end  
  
  test "should get survey" do
    get :survey
    assert_response :success
  end  
  
  test "should get tellfriends" do
    get :tellfriends
    assert_response :success
  end  
  
  test "should get tos" do
    get :tos
    assert_response :success
  end

  test "correct_head" do
  	get :home
  	assert_select 'title', "CrowdPublishTV - Actors Authors - Increase Fan Engagement & Earn More Funds"
  end


end
