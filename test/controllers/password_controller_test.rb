require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
      @user = users(:one)
    #@group = groups(:one)

  end

	test "should get new " do
	  get :new
	  assert_response :success
	end

	test "should edit password" do
    get :edit, params: {id: @user.id}
    assert_response :success
	end

end