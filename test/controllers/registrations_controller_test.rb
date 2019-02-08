require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase 

  setup do
    @user = users(:one)
  end
#test currently doesn't test for that
#   test "should update sanitized params" do
#   	sign_in @user
#     assert_difference('User.count', 1) do
#       post :update, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
#     end
# #    assert_equal(samiam, and what?)  #these tests dont seem to update the test db
#   end

end
