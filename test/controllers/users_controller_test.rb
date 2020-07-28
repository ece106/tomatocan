require 'test_helper'
class UsersControllerTest < ActionController::TestCase

  include ActionMailer::TestHelper

  setup do
    @user = users(:confirmedUser)
    # sign_in @user
  end

  test "should verify user twitter" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {twitter: 'MyTwitter'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("MyTwitter", user.twitter)
  end

  test "should verify user facebook" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {facebook: 'MyFacebook'} }
    user = User.find_by_permalink(@user.permalink)
    assert_equal("MyFacebook", user.facebook)
  end

  test "should verify update genre" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {genre1: 'Reading', genre2: 'Writing', genre3: 'Programming'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("Reading", user.genre1)
    assert_equal("Writing", user.genre2)
    assert_equal("Programming", user.genre3)
  end

  test "should get users show" do
    sign_in @user
    get :show, params: {permalink: 'userconfirmed'}
    assert_response :success
  end

  test "should get users eventlist user logged in" do
    sign_in @user
    get :eventlist, params: {permalink: 'userconfirmed'}
    assert_response :success
  end

  test "should get pastevents logged in" do
    sign_in @user
    user=User.find_by_permalink(@user.permalink)
    get :pastevents, params: {permalink: 'userconfirmed'}
    assert_response :success
  end

  test "should get users profileinfo" do
    sign_in @user
    get :profileinfo, params: { permalink: 'userconfirmed' }
    assert_response :success
  end

  test "should get changepassword" do
    get :changepassword, params: {permalink: 'userconfirmed'}
    assert_response :success
  end

  test "should get control panel logged in" do
    sign_in @user
    get :controlpanel, params: {permalink: 'userconfirmed',id: @user.id}
    assert_response :success
  end


  test "should get users dashboard logged in" do
    sign_in @user
    get :dashboard, params: {permalink: 'userconfirmed'}
    assert_response :success
  end

  #test "should get stripe callback" do
  #I have no clue how to play around with stripe yet
  test "should test stripe" do
    assert_nil ENV['STRIPE_SECRET_KEY'], @user.stripeid
    # NOTE: Don't hardcode stripeid. Use Environment variable instead.
    # stripeid="acct_1E4BAlKFKIozho71"
    # assert_equal(stripeid, @user.stripeid)
  end

  # rails test test/controllers/users_controller_test.rb -n test_should_equate_youtube_field;
  # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
  test "should create user" do
    assert_difference('User.count', 1) do
    post :create, params: { user: {name: 'TestUser', email: 'test@mail.com', password: 'secret123', password_confirmation: 'secret123', permalink: 'testuser' } }
    end
  end

  test "should redirect to new user path after successful creation" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_redirected_to (new_user_session_path)
  end

  test "should redirect to sign up path after failed creation" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    post :create, params: { user: { name: nil, email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_redirected_to (new_user_signup_path)
  end

  test "should flash message for creating user with incorrect name" do
    post :create, params: { user: { name: nil, email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_includes flash[:danger], @user.errors.messages[:name][0].to_s
  end

  test "should flash message for creating user with incorrect email" do
    post :create, params: { user: { name: 'samiam', email: nil, password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_includes flash[:danger], @user.errors.messages[:email][0].to_s
  end

  test "should flash message for creating user with incorrect permalink" do
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: '!@@@#%@#' } }
    assert_includes flash[:danger], @user.errors.messages[:permalink][0].to_s
  end

  test "should flash message for creating user with incorrect password" do
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: nil, password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_includes flash[:danger], @user.errors.messages[:password][0].to_s
  end

  test "should flash message for successful user creation" do
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_equal flash[:success], "You have successfully signed up! An email has been sent for you to confirm your account."
  end

  test "create method sends welcome email" do
    post :create, params: { user: { name: 'username', email: 'email@email.com', password: "password", password_confirmation: "password", permalink: 'plink' } }
    assert_enqueued_emails 1
  end

  test "should update user" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: 'New Name', youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    assert_equal(user.name, "New Name")
  end

  test "should send updateEmailMsg" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { email: "email@email.com"} }
    assert_equal flash[:info], "A confirmation message for your new email has been sent to: email@email.com to save changes confirm email first"
  end

  test "should redirect to user profile" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: 'New Name', youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    assert_redirected_to user_profile_path(user.permalink)
  end

  test "should verify update about" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {about: 'Hi this is me'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("Hi this is me", user.about)
  end

  test "should redirect to changepassword path if update password" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { on_password_reset: "changepassword", password:"newpass", password_confirmation:"newpass" } }
    user = User.find_by_permalink(@user.permalink)
    assert_redirected_to user_changepassword_path(user.permalink)
  end

  test "should redirect to profileinfo path if update failed" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { on_password_reset: !"changepassword", name: "b" * 55 } }
    user = User.find_by_permalink(@user.permalink)
    assert_redirected_to user_profileinfo_path(user.permalink)
  end

  test "should flash message for updating user with incorrect name" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: "b" * 55 } }
    assert_includes flash[:danger], @user.errors.messages[:name][0].to_s
  end

  test "should flash message for updating user with incorrect email" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { email: nil } }
    assert_includes flash[:danger], @user.errors.messages[:email][0].to_s
  end

  test "should flash message for updating user with incorrect permalink" do
    sign_in @user
    patch :update, params: {  id: @user.id, user: { permalink: "b" * 25 } }
    assert_includes flash[:danger], @user.errors.messages[:permalink][0].to_s
  end

  test "should flash message for updating user with incorrect password" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { password: nil } }
    assert_includes flash[:danger], @user.errors.messages[:password][0].to_s
  end

  test "should flash message for updating user with incorrect password_confirmation" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { password: 'secret12', password_confirmation: 'secret15' } }
    assert_equal flash[:danger], "Passwords do not match \n"
  end

  test "should flash message for updating user with incorrect twitter handle" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { twitter: '!@@@#%@#' } }
    assert_includes flash[:danger], @user.errors.messages[:twitter][0].to_s
  end

  test "should get followers" do
    get :followerspage, params: {permalink: 'userconfirmed', page: 1}
    assert_response :success
  end

  test "should get following" do
    get :followingpage, params: {permalink: 'userconfirmed', page: 2}
    assert_response :success
  end

  test "should return correct layout id" do
    sign_in @user
  # index, youtubers and supportourwork is obsolete, unable to test stripe_callback at the moment

  # profileinfo, changepassword
    get :profileinfo, params: { permalink: 'userconfirmed' }
    assert_template layout: "layouts/editinfotemplate"

  # other pages
    get :eventlist, params: {permalink: 'userconfirmed'}
    assert_template layout: "layouts/userpgtemplate"

    get :followerspage, params: {permalink: 'userconfirmed', page: 1}
    assert_template layout: "layouts/userpgtemplate"
  end
end