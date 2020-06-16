require 'test_helper'
class UsersControllerTest < ActionController::TestCase

  include ActiveJob::TestHelper

  setup do
    @user = users(:one)
    # sign_in @user
  end

  test "should get index" do
    get :index, params: {format: "text/html"}
    assert_response :success
  end


  test "should check index" do
    sign_in @user
    assert_equal(@user.id, 1)
  end
  test "should equate youtube field" do
    youtube="youtube"
    assert_equal(youtube,@user.youtube)
  end

  test "should get users youtubers" do
    get :youtubers, params: {format: "text/html"}
    assert_response :success
  end

  test "should verify user name" do
    sign_in @user
    assert_equal(@user.name, "Phineas")
  end

  test "should verify email" do
    sign_in @user
    assert_equal("fake@fake.com", @user.email)
  end

  test "should recognize youtubers"do
    assert_recognizes({controller: 'users',action:'youtubers'},'youtubers')
  end

  test "should recognize supportourwork"do
    assert_recognizes({controller: 'users',action:'supportourwork'},'supportourwork')
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
    assert_equal("facebook", @user.facebook)
  end

  test "should verify update genre1" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {genre1: 'Writing'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("Writing", user.genre1)
  end

  test "should verify update genre2" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {genre1: 'Reading'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("Reading", user.genre1)
  end

  test "should verify update genre3" do
    sign_in @user
    patch :update, params:{ id: @user.id, user: {genre1: 'Programming'}}
    user = User.find_by_permalink(@user.permalink)
    assert_equal("Programming", user.genre1)
  end


  test "should get users show" do #user1 has phases
    get :show, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get users eventlist user logged in" do
    get :eventlist, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get pastevents logged in" do
    sign_in @user
    user=User.find_by_permalink(@user.permalink)
    get :pastevents, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should recognize pastevents" do
    get :pastevents, params: {permalink: 'user1'}
    assert_recognizes({controller: 'users',action:'pastevents', permalink:'user1'},'user1/pastevents')
  end

  test "should get users profileinfo" do
    sign_in @user
    get :profileinfo, params: { permalink: 'user1' }
    assert_response :success
  end

  test "should get changepassword" do
    get :changepassword, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should recognize users dashboard logged in"do
    assert_recognizes({controller: 'users',action:'dashboard',permalink:'user1'},'user1/dashboard')
  end

  test "should get control panel logged in" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
    #   puts @book.id
    #   puts "Notice that the book id is some ridiculously huge integer."
    get :controlpanel, params: {permalink: 'user1',id: @user.id}
    assert_response :success
  end


  test "should get users dashboard logged in" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
    #   puts @book.id
    #   puts "Notice that the book id is some ridiculously huge integer."
    get :dashboard, params: {permalink: 'user1'}
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
    user = User.create(name: 'TestUser', email: 'test@mail.com', password: 'secret123', password_confirmation: 'secret123', permalink: 'testuser')
    assert_not_nil user
    # assert_equal(User.count, 2) do
    #   post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    # end
  end

  test "should redirect new user" do # To test whether address/zip from IP is saved, need to test registrations controller. But can't do on localhost.
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_redirected_to (user_profileinfo_path(assigns(:user).permalink))
  end

  test "should check new user index" do
    post :create, params: { user: { name: 'samiam', email: 'fakeunique@fake.com', password: 'secret12', password_confirmation: 'secret12', permalink: 'samlink' } }
    assert_equal(@user.id,1)

  end

  test "should show user profile" do #user2 has no phases
    get :show, params: {permalink: 'user2' }
    assert_response :success
  end

  test "should update user" do
    sign_in @user
    patch :update, params: { id: @user.id, user: { name: 'New Name', youtube1: 'randomchar' } }
    user = User.find_by_permalink(@user.permalink)
    assert_equal(user.name, "New Name")
  end

  test "should redirect to user" do
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

  test "should get followers" do
    get :followerspage, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get following" do
    get :followingpage, params: {permalink: 'user1'}
    assert_response :success
  end

  #  test "should get followers by user id" do
  #    sign_in @user
  #    get :followers , params:{ id: @user.id}
  #    assert_response :success
  #  end


  test "should get follower number" do
    sign_in @user
    get :followerspage, params: {permalink: 'user1'}
    assert_equal(@user.followers.count, 0)
  end

  test "should get following number" do
    sign_in @user
    get :followingpage, params: {permalink: 'user1'}
    assert_equal(@user.following.count, 0)
  end

  #Implement follower and following test,

  #purchid needs to be implemented

  # test "should post mark fulfilled" do

  #   sign_in @user
  # #  post :markfulfilled, params: {purchid: '1'}
  #   assert_response :success
  # end

  test "should get control panel for user1" do
    sign_in @user
    get :controlpanel, params: {permalink: 'user1'}
    assert_response :success
  end

  test "should get control panel for user2" do
    sign_in @user
    get :controlpanel, params: {permalink: 'user2'}
    assert_response :success
  end

  test "create method sends welcome email" do
    get :create, params: { user: { name: 'username', email: 'email@email.com', password: "password", password_confirmation: "password", permalink: 'plink' } }
    assert_enqueued_jobs(1)
  end
end
