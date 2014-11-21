class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  # GET /events.json
  def index
    @events = Event.all
    if params[:search].present?
      @events = Event.near(params[:search], params[:dist], order: 'distance') 
    elsif user_signed_in? && current_user.address
      @events = Event.near([current_user.latitude, current_user.longitude], 25, order: 'distance') 
    else
      @events = Event.near(20016, 100, order: 'distance')
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @tempval = 0
    if current_user.address
      @groups = Group.near([current_user.latitude, current_user.longitude], 50, order: 'distance') 
    else
      @groups = Group.near(20016, 100, order: 'distance')
    end
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.build(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
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

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
end


  private

    def event_params
      params.require(:event).permit(:address, :name, :start_at, :end_at, :desc, :latitude, :longitude, :rsvp, :user_id, :group1id, :group2id, :group3id )
    end
