require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "correct_head" do
  	get :home
  	assert_select 'title', "CrowdPublishTV - Actors Authors - Increase Fan Engagement & Earn More Funds"
  end

  test "correct_homepage_when_logged_in" do
  	
  end


end
