require 'test_helper'
class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
   # sign_in @user
  end
#index view does not exist
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:users)
  # end

  test "should equate youtube field" do
    youtube="youtube"
    assert_equal(youtube,@user.youtube)
  end

  test "should get users youtubers" do
    get :youtubers
    assert_response :success
  end

  test "should recognize youtubers"do
    assert_recognizes({controller: 'users',action:'youtubers'},'youtubers')
  end

  test "should get users supportourwork" do
    get :supportourwork
    assert_response :success
  end

  test "should recognize supportourwork"do
    assert_recognizes({controller: 'users',action:'supportourwork'},'supportourwork')
  end
  test "should recognize users dashboard logged in"do
    assert_recognizes({controller: 'users',action:'dashboard',permalink:'user1'},'user1/dashboard')
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

  test "should not get users dashboard logged out" do
    sign_in @user
    @book = books(:one)
    @purchase = purchases(:one)
 #   puts @book.id
 #   puts "Notice that the book id is some ridiculously huge integer."
    get :dashboard, params: {permalink: 'user2'}
    assert_response :success
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
   
  test "should get users eventlist user logged in" do
    get :eventlist, params: {permalink: 'user1'}
    assert_response :success
  end
  test "scratch" do
    get :youtubers
    assert_equal(@applesauce,1)
  end
end
