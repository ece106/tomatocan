require 'test_helper'

class BooksControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @user = users(:one)
    @book = books(:one)
  end

#  test "should get index" do  # Figure out what a book list, search will look like later

  test "should create book" do
    assert_difference('Book.count') do
      post :create, params: {book: @book.attributes}
    end
    assert_redirected_to user_profile_path(@user.permalink)
  end

  test "should show book" do
    get :show, params: {id: @book}
    assert_response :success
  end

  test "should update book" do
    put :update, params: {id: @book.to_param, book: @book.attributes}
    assert_redirected_to user_profile_path(@user.permalink)
  end

#  test "should destroy book" do... Not enabled. Test for disabled status instead

end
