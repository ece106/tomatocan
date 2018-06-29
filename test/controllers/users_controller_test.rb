require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
#    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should create user" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    assert_difference('User.count', 1) do
      post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', 
           password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    end

    assert_redirected_to user_profileinfo_path(assigns(:user).permalink)
  end

  test "should show user profile" do #user without any phases
    get :show, params: {permalink: 'user2' }
    assert_response :success
  end

#  test "should get edit" do  # my edit page is more complicated
#    get :edit, id: @user.to_param
#    @book = current_user.books.build
#    @booklist = Book.where(:user_id => @user.id)
#    assert_response :success
#  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end


  test "should update user" do
    sign_in @user
#    get user_profileinfo_path(@user.permalink)
    puts @user.name

    patch :update, params: { id: @user.id, user: { name: 'New Name', 
      youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    puts user.name
    assert_equal(user.name, "New Name") 
    assert_redirected_to user_profile_path(user.permalink)
  end

end