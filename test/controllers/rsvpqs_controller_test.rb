require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase
  setup do
    @rsvpq = rsvpqs(:one)
  end

  test "should get index" do
    sign_in users(:one)
    get :index
    assert_response :success
    assert_not_nil assigns(:rsvpqs)
  end

  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end


  test "should create rsvpq" do
    assert_difference('Rsvpq.count',1) do
      post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id } }
    end
    #assert_redirected_to events_path
     assert_redirected_to "http://test.host/login"
  end

  test "should show rsvpq" do
    sign_in users(:one)
    get :show, params:{ id: @rsvpq}
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:one)
    get :edit, params: { id: @rsvpq}
    assert_response :success
  end

  test "should update rsvpq" do
    patch :update, params:{id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id } }
    #assert_redirected_to rsvpq_path(assigns(:rsvpq))
     assert_redirected_to "http://test.host/login"
  end

  test "should display FLASH message for invalid email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, email: "notavalidemail" } }
    #assert flash[:notice], 'Please enter a valid email address'
    assert_equal 'Please enter a valid email address', flash[:notice]
  end

end
