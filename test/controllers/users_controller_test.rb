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

  test "should_get_users_about" do
    get :about, params: {permalink: 'user1'}
    assert_response :success

    get :about, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_addbankaccount_not_loggedin" do
    # Redirects to login page if user is currently not logged in
    get :addbankaccount, params: {permalink: 'user1'}
    assert_redirected_to "/login"
  end

  test "should_get_users_addbankaccount_loggedin" do
    # If user is logged in go to correcterrors page
    sign_in @user
    get :addbankaccount, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_authors" do
    get :authors, params: {permalink: 'user1'}
    assert_response :success

    get :authors, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should get_users_blog" do
    get :blog, params: {permalink: 'user1'}
    assert_response :success

    get :blog, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should get_users_booklist" do
    get :booklist, params: {permalink: 'user1'}
    assert_response :success

    get :booklist, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should get_users_correcterrors_not_loggedin" do
    # Redirects to login page if user is currently not logged in
    get :correcterrors, params: {permalink: 'user1'}
    assert_redirected_to "/login"
  end

  test "should_get_users_correcterrors_loggedin" do
    # If user is logged in go to correcterrors page
    sign_in @user
    get :correcterrors, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_createstripeaccount_not_loggedin" do
    # Redirects to login page if user is currently not logged in
    get :createstripeaccount, params: {permalink: 'user1'}
    assert_redirected_to "/login"
  end

  test "should_get_users_createstripeaccount_loggedin" do
    # If user is logged in go to createstripeaccount page
    sign_in @user
    get :createstripeaccount, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_dashboard" do
    sign_in @user
    get :dashboard, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_edit_non_loggedin" do
    # Redirects to login page if user is currently not logged in
    get :edit, params: {permalink: 'user1'}
    assert_redirected_to "/login" 
  end

  test "should_get_users_edit_loggedin" do
    # If user is logged in go to edit page
    sign_in @user
    get :edit, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_eventlist" do
    get :eventlist, params: {permalink: 'user1'}
    assert_response :success

    get :eventlist, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_groups" do
    get :groups, params: {permalink: 'user1'}
    assert_response :success

    get :groups, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_manageaccounts" do
    sign_in @user
    get :manageaccounts, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_movieedit" do
    sign_in @user
    get :movieedit, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should_get_users_movielist" do
    get :movielist, params: {permalink: 'user1'}
    assert_response :success

    get :movielist, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_pastevents" do
    get :pastevents, params: {permalink: 'user1'}
    assert_response :success

    get :pastevents, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_perks" do
    get :perks, params: {permalink: 'user1'}
    assert_response :success

    get :perks, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_phases" do
    get :phases, params: {permalink: 'user1'}
    assert_response :success

    get :phases, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_profileinfo" do
    get :profileinfo, params: {permalink: 'user1'}
    assert_response :success

    get :profileinfo, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_readerprofileinfo" do
    get :readerprofileinfo, params: {permalink: 'user1'}
    assert_response :success

    get :readerprofileinfo, params: {permalink: 'user2'}
    assert_response :success
  end

  test "should_get_users_show" do
    get :show, params: {permalink: 'user1'}
    assert_response :success
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