require 'test_helper'

class Users::PasswordsController < ActionController::TestCase
  setup do
      @user = users(:one)
      
      #@group = groups(:one)

  end

  #test run to assert a new password index can be found
    # test "should get new " do
    #    get :new
    #   assert_response :success
    #  end

#test run to assert user can create a new password 
#should check if successful reset password email was sent


#test run to assert user can edit their password 

  # # test "should edit password" do
 # #    get :edit, params: {id: @user.id}
 # #    assert_response :success
  # # end


   # test "should password for user" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
  #     assert_difference('User.count', 1) do
  #     post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', 
  #          password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
  #   end
  #   assert_redirected_to user_profileinfo_path(assigns(:user).permalink)
  # end

  #test run to assert update password successfully
  #should check whether throws the right flags base on if the password meets neccesary requirements i.e. length
end