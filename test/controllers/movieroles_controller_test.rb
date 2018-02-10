require 'test_helper'

class MovierolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movierole = movieroles(:one)
  end

  test "should get index" do
    get movieroles_url
    assert_response :success
  end

  test "should get new" do
    get new_movierole_url
    assert_response :success
  end

  test "should create movierole" do
    assert_difference('Movierole.count') do
      post movieroles_url, params: { movierole: { movie_id: @movierole.movie_id, role: @movierole.role, roledesc: @movierole.roledesc, user_id: @movierole.user_id } }
    end

    assert_redirected_to movierole_url(Movierole.last)
  end

  test "should show movierole" do
    get movierole_url(@movierole)
    assert_response :success
  end

  test "should get edit" do
    get edit_movierole_url(@movierole)
    assert_response :success
  end

  test "should update movierole" do
    patch movierole_url(@movierole), params: { movierole: { movie_id: @movierole.movie_id, role: @movierole.role, roledesc: @movierole.roledesc, user_id: @movierole.user_id } }
    assert_redirected_to movierole_url(@movierole)
  end

  test "should destroy movierole" do
    assert_difference('Movierole.count', -1) do
      delete movierole_url(@movierole)
    end

    assert_redirected_to movieroles_url
  end
end
