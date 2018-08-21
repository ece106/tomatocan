require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @movie = movies(:one)
    @user = users(:one)
  end


    test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end


   test "should create group" do
    sign_in @user
    assert_difference('Movie.count', 1) do
      post :create, params:{ movie: { about: @movie.about,genre: @movie.genre, moviepic: @movie.moviepic, price: @movie.price, title: @movie.title, videodesc1: @movie.videodesc1, videodesc2: @movie.videodesc2, videodesc3: @movie.videodesc3, youtube1: @movie.youtube1, youtube2: @movie.youtube2, youtube3: @movie.youtube3 } }
    end
        assert_redirected_to "http://test.host/user1"
  end


  test "should show group" do
     sign_in users(:one)
     get :show, params: { id: @movie.user_id}
    assert_response :success
  end


  test "should get edit" do 
    sign_in users(:one)
    get :edit, params: { id: @movie }
    assert_response :success
  end


   test "should update group" do
    sign_in users(:one)
    patch :update, params:{ id: @movie, movie: { about: @movie.about,genre: @movie.genre, moviepic: @movie.moviepic, price: @movie.price, title: @movie.title, videodesc1: @movie.videodesc1, videodesc2: @movie.videodesc2, videodesc3: @movie.videodesc3, youtube1: @movie.youtube1, youtube2: @movie.youtube2, youtube3: @movie.youtube3 } }
    assert_redirected_to "http://test.host/user1"
  end


end
