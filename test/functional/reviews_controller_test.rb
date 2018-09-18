require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do
    @review = reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      post :create, params: { review: @review.attributes }
    end

    assert_redirected_to review_path(assigns(:review))
  end

  test "should show review" do
    get :show, params: { id: @review.to_param }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @review.to_param }
    assert_response :success
  end

  test "should update review" do
    put :update, params: { id: @review.to_param, review: @review.attributes }
    assert_redirected_to review_path(assigns(:review))
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete :destroy, params: { id: @review.to_param }
    end

    assert_redirected_to reviews_path
  end
end
