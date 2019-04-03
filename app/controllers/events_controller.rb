class EventsController < ApplicationController
#  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_user!, only: [:edit, :update, :new, :create]
  # GET /events.json
  def index
    @events = Event.where( "start_at > ?", Time.now )
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def pastevents
    @events = Event.where( "start_at < ?", Time.now )
    if params[:search].present?
      if params[:dist].present? && is_number?(params[:dist])
        @events = @events.near(params[:search], params[:dist], order: 'distance') 
      else
        @events = @events.near(params[:search], 50, order: 'distance') 
      end
    end
  end

  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.usrid)
    @rsvp = Rsvpq.new
    @rsvpusers = @event.users
    @rsvps = @event.rsvpqs
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new.json
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events.json
  def create
    @event = current_user.events.build(event_params)

    respond_to do |format|
      if @event.save
#        redirect_to @event
        format.html { redirect_to "/" }
        format.json { render json: @event, status: :created, location: @event }
      else
#        format.html { redirect_to new_event_path }
 #       redirect_to new_event_path, :notice => "Your event was not saved. Check for improper input."
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to @event }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def event_params
      params.require(:event).permit(:address, :name, :start_at, :end_at, :desc, :latitude, :longitude, :usrid, :user_id, :group1id, :group2id, :group3id )
    end

    def is_number?(obj)
      obj.to_s == obj.to_i.to_s
    end

end
