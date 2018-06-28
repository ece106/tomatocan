require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
#    sign_in @user
  end
  
  def create
    @user = User.new(user_params)
#    @user.latitude = request.location.latitude
#    @user.longitude = request.location.longitude

    if @user.save
      sign_in @user
      redirect_to user_profile_path(current_user.permalink)
    else
      render 'signup'
    end
  end

  test "should get index" do
    #throwing SQL exception
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should create user" do 
    assert_difference('User.count', 1) do
<<<<<<< HEAD
<<<<<<< HEAD
      post :create, user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', 
                    password_confirmation: 'secret12', permalink: 'samlink'  }
    end
    assert_redirected_to user_profile_path(assigns(:user).permalink)
=======
      post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
=======
      post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', 
           password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
>>>>>>> 2669234810cde74bbfebe105d72b90076868d7df
    end

    assert_redirected_to user_profileinfo_path(assigns(:user).permalink)
>>>>>>> f9c9e59abd61cfac4c7f2c3c98c5d7c54d7a4a28
  end

<<<<<<< HEAD
#  test "should create user" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
#    assert_difference('User.count', 2) do
#      post :create, user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink'  }
#    end
#    assert_redirected_to user_profile_path(assigns(:user).permalink)
#  end

  test "should show user" do
    get :show, params: { permalink: "user1" }
=======
  test "should show user profile" do #user without any phases
    get :show, params: {permalink: 'user2' }
>>>>>>> 2669234810cde74bbfebe105d72b90076868d7df
    assert_response :success
  end

#  test "should get edit" do  # my edit page is more complicated
#    get :edit, id: @user.to_param
#    @book = current_user.books.build
#    @booklist = Book.where(:user_id => @user.id)
#    assert_response :success
#  end

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
