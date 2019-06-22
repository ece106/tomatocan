require 'test_helper'
class EventsControllerTest < ActionController::TestCase
  setup do
    @event = events(:one)
    @user = users(:one)
    @user_two = users(:two)
    @rsvpq = rsvpqs(:one)
  end

  test "should retrieve list of all events"do
    get :index, params: {id: @event.id}
    assert_response :success
  end
  test "should show event" do
    get :show, params: {id: @event.id}
    assert_response :success
  end
  test "should get new event" do
    sign_in users(:one)
    get :new
    assert_response :success
  end
  test "should get edit if user is signed in" do
    sign_in users(:one)
    get :edit, params: { id: @event.id }
    assert_response :success
  end
  test "should create events" do
    sign_in users(:one)
    assert_difference('Event.count', 1) do
      post :create, params: { event: {start_at: "2010-02-11 11:02:57", usrid: '1', name: 'Phineas' } }
    end
  end
  test "should redirect if events are created" do
    sign_in users(:one)
    post :create, params: { event: {start_at: "2010-02-11 11:02:57", usrid: '1', name: 'Phineas'  } }
    assert_redirected_to '/'
  end
  test "should verify if event was created" do
    sign_in users(:one)
    post :create, params: { event: { start_at: "2010-02-11 11:02:57", usrid: '1', name: 'Phineas'  } }
    assert_empty @event.errors.messages
  end
  test "should redirect after updating" do
    sign_in users(:one)
    patch :update, params: {id: @event.id, event: {start_at: "2010-02-11 11:02:57",  usrid: '1', name: 'Phineas'  }}
    assert_redirected_to event_path(@event.id)
  end
  test "should verify event update" do
    sign_in users(:one)
    patch :update, params: {id: @event.id, event: {start_at: "2010-02-11 11:02:57", usrid: '1', name: 'Phineas' }}
    assert_empty @event.errors.messages
  end

  test "create should send email to followers" do
    sign_in @user
    sign_in @user_two
    @user_two.follow(@user)
    post :create , params: {event: {start_at: "2010-02-11 11:02:57", usrid: @user.id, name: @user.name}}
    email = ActionMailer::Base.deliveries.last
    assert_equal [@user_two.email.to_s] , email.to
    assert_equal 1, ActionMailer::Base.deliveries.size

  end
#write a test for rsvpq for show
end
