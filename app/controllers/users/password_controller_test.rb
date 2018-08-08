require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @password = passwords(:one)
#    sign_in @user
  end

test "should get index"
  get :new
  assert_response :success
end