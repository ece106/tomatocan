require 'test_helper'
class EventsControllerTest < ActionController::TestCase
    setup do
    @event = events(:one)
    @user = users(:one)
    @rsvpq = rsvpqs(:one)
    end

    #event.usrid==1
    #event.id==980190962

    #index
    test "should_retrieve_list_of_all_events" do
        get :index, params: {id: @event.id}
        #get :index
        assert_response :success
    end

    test "should accquire events greater than starting time" do 
        #user1 = User.create(:id => 4, :name => 'Ichi-chan')
        @event1 = Event.create(:usrid => 2, :name => 'Dark Water', :start_at => "2020-02-11 11:02:57")
        sample_event = Event.where( "start_at > ?", Time.now )
        assert_equal(@event1.usrid, sample_event[0].usrid)
    end 
    
    test "should render index view" do
        get :index, params: {id: @event1, format: :html}
        assert_response :success 

        get :index, params: {id: @event1, format: :json}
        assert_response :success 
    end

    test "should_recognize_events" do
        assert_recognizes({:controller => 'events', :action => 'index'}, {:path => 'events', :method => :get})
        #assert_recognizes({:controller =>'events', :action =>'show', :id =>'index'}, 'events/index')
    end

    #show
    test "should find event" do
        get :show, params: {id: @event.id}
        assert_response :success
        assert_not_nil(@event.usrid, msg = nil)
    end

    test "should find user" do
        #get :show, params: {id: @event}
        #assert_response :success
        user = User.find(@event.usrid)
        assert_equal user.id, @event.usrid
    end

    test "should initalize new rsvp" do
        rsvp = Rsvpq.new
        assert_equal true, rsvp.event.nil?
    end


    test "should_initialize_rsvpusers_as_the_event_user" do
       #rsvpuser = @event.users
       #uid = @event.usrid
       #users(:two).update_column(:id, uid)
       rsvpuser = @event.rsvpqs
       rsvpuser.each do |num|
            puts num.user.inspect
       end 
       flunk (msg = "gonna get cody's help on this")
    end

    test "should initialize rsvps as event rsvps" do
        rsvp = @event.rsvpqs
        rsvp.each do |num|
            puts num.inspect
        end  
        assert_equal rsvp[0].event, @event
    end

    test "show_render_show_view" do
        get :show, params: {id: @event, format: :html}
        assert_response :success 

        get :show, params: {id: @event, format: :json}
        assert_response :success 
    end    

    #new
    test "should get new event" do
        sign_in users(:one)
        get :new
        assert_response :success
    end

    #edit
    test "should be able to edit if user is signed in" do
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

end
