require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase
  setup do
    @rsvpq = rsvpqs(:one)
    @user= users(:one)
  end

#there is no new view
=begin  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end
=end
#there are no events
  test "should create rsvpq" do
    assert_difference('Rsvpq.count',1) do
      sign_in @user
      post :create, params: {rsvpq: { event_id: @rsvpq.event_id } }
    end
    #assert_redirected_to events_path
    # assert_redirected_to "http://test.host/login"
  end

  test "should show rsvpq" do
    sign_in users(:one)
    get :show, params:{ id: @rsvpq}
    assert_response :success
  end
#there is no edit view
=begin  test "should get edit" do
    sign_in users(:one)
    get :edit
    assert_response :success
  end
=end
#there is no update view
=begin
  test "should update rsvpq" do
    patch :update, params:{id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id } }
    #assert_redirected_to rsvpq_path(assigns(:rsvpq))
     assert_redirected_to "http://test.host/login"
  end
=end
  test "should display FLASH message for invalid email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, email: "notavalidemail" } }
    #assert flash[:notice], 'Please enter a valid email address'
    assert_equal 'Please enter a valid email address', flash[:notice]
  end

end
