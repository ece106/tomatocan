require 'test_helper'

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie = movies(:one)
  end

  test "should get index" do
    get movies_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_url
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post movies_url, params: { movie: { about: @movie.about, genre: @movie.genre, moviepic: @movie.moviepic, price: @movie.price, title: @movie.title, videodesc1: @movie.videodesc1, videodesc2: @movie.videodesc2, videodesc3: @movie.videodesc3, youtube1: @movie.youtube1, youtube2: @movie.youtube2, youtube3: @movie.youtube3 } }
    end

    assert_redirected_to movie_url(Movie.last)
  end

  test "should show movie" do
    get movie_url(@movie)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie), params: { movie: { about: @movie.about, genre: @movie.genre, moviepic: @movie.moviepic, price: @movie.price, title: @movie.title, videodesc1: @movie.videodesc1, videodesc2: @movie.videodesc2, videodesc3: @movie.videodesc3, youtube1: @movie.youtube1, youtube2: @movie.youtube2, youtube3: @movie.youtube3 } }
    assert_redirected_to movie_url(@movie)
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete movie_url(@movie)
    end

    assert_redirected_to movies_url
  end
end
