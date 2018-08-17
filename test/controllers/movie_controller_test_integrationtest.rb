require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
    @user = users(:one)
  end

  test "should get index" do
  	get "/movies/"
  	assert_response :success
  end

	test "should get1 index" do
     get movies_url
     assert_response :success
   end
 end