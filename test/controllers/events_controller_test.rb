require 'test_helper'
class EventsControllerTest < ActionController::TestCase
    setup do
    @event = events(:one)
    @user = users(:one)
    @rsvpq = rsvpqs(:one)
    end

    #index
    # test "should retrieve list of all events"do
    #     get :index, params: {id: @event.id}
    #     assert_response :success
    # end

    #show
    test "should show event" do
        get :show, params: {id: @event.id}
      assert_response :success
    end

    test "should find event user" do
        #@event = events(:one)
        get :show, params: {usrid: @event.usrid}
      assert_response :success
    end

    test "should initalize new rsvp" do
         #sign_in users(:one)
         get :show
       assert_response :success
    end

    # test "should initialize rsvpusers as the event user" do

    # end

    test "should recognize events"do
         assert_recognizes({:controller => 'events', :action => 'index'}, {:path => 'events', :method => :get})
    end



    #new
    test "should get new event" do
        sign_in users(:one)
        get :new
        assert_response :success
    end

    #edit
    test "should get edit if user is signed in" do
        sign_in users(:one)
        get :edit, params: { id: @event.id }
        assert_response :success
    end

    #create
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
    #update
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
#write a test for rsvpq for show

end
