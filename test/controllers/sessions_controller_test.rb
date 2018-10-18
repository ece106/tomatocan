require './test/test_helper'

class SessionsControllerTest < ActionController::TestCase 
    setup do
        sign_in users(:one)
    end

    test "logged in should get show" do
        get :new
        assert_response :success
    end
end