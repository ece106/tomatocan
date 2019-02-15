<<<<<<< HEAD
=======
require 'test_helper'
class EventsControllerTest < ActionController::TestCase
    setup do
    @event = events(:one)
    end

    test "should get new event" do
        sign_in users(:one)
        get :new
        assert_response :success
    end
    test "should get past events" do
        get :pastevents
        assert_response :success
    end
    test "should get edit if user is signed in" do
        sign_in users(:one)
        get :edit, params: { id: @event.id }
        assert_response :success
    end
    test "should get index" do
        get :index
        assert_response :success
    end
    test "should create events" do
        sign_in users(:one)
         assert_difference('Event.count', 1) do
             post :create, params: { event: { usrid: '1', name: 'Phineas' } }
         end
    end
end
>>>>>>> 306c7e73bf1132481251cc997d5b74faf07b09b5
