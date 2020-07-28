require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase

  include ActionMailer::TestHelper
  
  setup do
    @rsvpq = rsvpqs(:valid_rsvpq_one)
    @event = events(:confirmedUser_event)
  end

  test "should create rsvpq when signed in" do
    sign_in users(:confirmedUser)
    request.headers['referer'] = home_path
    assert_difference('Rsvpq.count', 1) do
    post :create, params: { rsvpq: { event_id: 3 } }
    end
  end

  test "should redirect to home_path after successful creation, signed in" do
  sign_in users(:confirmedUser)
  request.headers['referer'] = home_path
  post :create, params: { rsvpq: { event_id: 3 } }
  assert_redirected_to home_path
  end

  test "should display FLASH message for successful creation, signed in" do
    sign_in users(:confirmedUser)
    request.headers['referer'] = home_path
    post :create, params: { rsvpq: { event_id: 3 } }
    assert_equal 'Rsvp was successfully created.', flash[:success]
  end  

  test "should send reminder email when signed in" do
    sign_in users(:confirmedUser)
    request.headers['referer'] = home_path
    post :create, params: { rsvpq: { event_id: 3 } }
    assert_enqueued_emails 1
  end

  test "should create rsvpq with email" do
    assert_difference('Rsvpq.count', 1) do
      request.headers['referer'] = home_path
      post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
    end
  end

  test "should redirect to home_path after successful creation, valid email" do
    request.headers['referer'] = home_path
    post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
    assert_redirected_to home_path
  end

  test "should display FLASH message for successful creation, valid email" do
    request.headers['referer'] = home_path
    post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
    assert_equal 'Rsvp was successfully created.', flash[:success]
  end  

  test "should send reminder email if email valid" do
    request.headers['referer'] = home_path
    post :create, params: { id: @rsvpq.id, rsvpq: { event_id: @event.id, email: 'validemail@email.com' } }
    assert_enqueued_emails 1
  end

  test "should redirect back after unsuccessful creation, invalid email" do
    post :create, params: {id: @rsvpq.id, rsvpq: { email: 'notavalidemail' } }
    assert_redirected_to root_path  
  end

  test "should not modify database after unsuccessful creation, invalid email" do
    assert_no_difference 'Rsvpq.count' do
    post :create, params: {id: @rsvpq.id, rsvpq: { email: 'notavalidemail' } }
    end
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
