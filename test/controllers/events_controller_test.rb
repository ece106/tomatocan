require 'test_helper'
class EventsControllerTest < ActionController::TestCase
     include ActiveJob::TestHelper
  setup do
    @event = events(:one)
    @user = users(:one)
    @user_two = users(:two)
    @rsvpq = rsvpqs(:one)
  end

  #event.user_id==1
  #event.id==980190962

    #index
    test "#index should return all events with start at greater than current time" do
        @event1 = Event.create(:user_id => 2, :name => 'Dark Water', :start_at => "2020-02-11 11:02:57")
        sample_event = Event.where( "start_at > ?", Time.now )
        assert_equal(@event1.user_id, sample_event[2].user_id)
    end
    
    test "#index should respond to the correct format" do
        get :index, params: {id: @event.id, format: :html}
        assert_response :success 

        get :index, params: {id: @event.id, format: :json}
        assert_response :success 
    end

    #show
    test "#show should find correct event" do
        get :show, params: {id: @event.id}
        assert_response :success
        
        assert_not_nil(@event.user_id, msg = nil)
    end

    test "#show should find correct user" do
        get :show, params: {id: @event.id}
        assert_response :success
       
        user = User.find(@event.user_id)
        assert_equal user.id, @event.user_id
    end

    test "#show should initalize new rsvp" do
        get :show, params: {id: @event.id}
        assert_response :success
        
        rsvp = Rsvpq.new
        assert_equal true, rsvp.event.nil?
    end


    test "#show should have the correct count for rsvpusers" do
        get :show, params: {id: @event.id}
        assert_response :success
        
        @event_three = events(:three)
        @valid_rsvpq_one = rsvpqs(:valid_rsvpq_one)
        @valid_rsvpq_two = rsvpqs(:valid_rsvpq_two)
        rsvpusers = @event_three.users
        
        assert_equal rsvpusers.count, 2
    end

    test "#show should initialize rsvps as event rsvps" do
        get :show, params: {id: @event.id}
        assert_response :success

        @event_three = events(:three)
        @valid_rsvpq_one = rsvpqs(:valid_rsvpq_one)
        @valid_rsvpq_two = rsvpqs(:valid_rsvpq_two)
        rsvps = @event_three.rsvpqs
        assert_equal rsvps.count, 2
    end

    test "#show should respond to the correct format" do
        get :show, params: {id: @event.id, format: :html}
        assert_response :success 

        get :show, params: {id: @event.id, format: :json}
        assert_response :success 
    end    

    #new
    test "#new should instantiate new event object" do
        sign_in users(:one)
        get :new
        assert_response :success
    end

    #edit
    test "#edit should be able to edit if user is signed in" do
        sign_in users(:one)
        get :edit, params: { id: @event.id }
        assert_response :success
    end

    #create
    test "#create should create events" do
        sign_in users(:one)
         assert_difference('Event.count', 1) do
             post :create, params: { event: {start_at: "2010-02-11 11:02:57", end_at: "2010-02-12 11:02:57", user_id: '1', name: 'Phineas' } }
         end
    end

    test "#create should redirect if events are created and saved" do
        sign_in users(:one)
        post :create, params: { event: {start_at: "2010-02-11 11:02:57", user_id: '1', name: 'Phineas'  } }
           assert_redirected_to '/'
    end

    test "#create should verify if event was created" do
      sign_in users(:one)
      post :create, params: { event: { start_at: "2010-02-11 11:02:57", user_id: '1', name: 'Phineas'  } }
        assert_empty @event.errors.messages
    end

    #update
    test "#update should redirect after updating" do
        sign_in users(:one)
        patch :update, params: {id: @event.id, event: {start_at: "2010-02-11 11:02:57",  user_id: '1', name: 'Phineas'  }}
        assert_redirected_to event_path(@event.id)
    end
    
    test "#update should verify event update" do
        sign_in users(:one)
        #patch :update, params: {id: @event.id, event: {start_at: "2010-02-11 11:02:57", user_id: '1', name: 'Phineas' }}
        patch :update, params: {id: '1', event: { start_at: "2010-03-11 11:03:57", end_at: "2010-02-11 11:02:57", user_id: '1', name: 'asdfas'}}
        assert_empty @event.errors.messages
    end

  test 'create should send a reminder functional test' do
    sign_in @user
    post :create , params: {event: {start_at: Time.now + 2.days, user_id: @user.id, name: @user.name}}
    assert_enqueued_jobs(1)
  end
end