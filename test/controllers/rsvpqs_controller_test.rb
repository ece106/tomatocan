require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase
  setup do
    @rsvpq = rsvpqs(:one)
    @event = events(:one)
  end


  test "should create rsvpq with email" do
   assert_difference('Rsvpq.count', 1) do
     post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
     end
  end

  test "should create rsvpq when signed in" do
    sign_in users(:one)
    assert_difference('Rsvpq.count', 1) do
    post :create, params: { rsvpq: { event_id: @event.id } }
    end
  end

  test "should redirect to home_path after successful creation, signed in" do
  sign_in users(:one)
  post :create, params: { rsvpq: { event_id: @event.id } }
  assert_redirected_to home_path
  end

  test "should redirect to home_path after successful creation, valid email" do
    post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
    assert_redirected_to home_path
  end

  test "should redirect back after unsuccessful creation, invalid email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { email: 'notavalidemail' } }
    assert_redirected_to root_path
  end

  test "should display FLASH message for invalid email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { email: 'notavalidemail' } }
    assert_equal 'Please enter a valid email address', flash[:error]
  end

  test "should display FLASH message for blank email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { email: '' } }
    assert_equal 'Please enter a valid email address', flash[:error]
  end

  #passes
  test "should show rsvpq" do
    get :show, params:{ id: @rsvpq}
    assert_response :success
  end

end
