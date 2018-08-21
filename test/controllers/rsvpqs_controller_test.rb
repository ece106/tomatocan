require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase
  setup do
    @rsvpq = rsvpqs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rsvpqs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rsvpq" do
    assert_difference('Rsvpq.count',1) do
      post :create, params: { rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id } }
    end
    assert_redirected_to events_path
  end

  test "should show rsvpq" do
    get :show, id: @rsvpq
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rsvpq
    assert_response :success
  end

  test "should update rsvpq" do
    patch :update, id: @rsvpq, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id }
    assert_redirected_to rsvpq_path(assigns(:rsvpq))
  end

end
