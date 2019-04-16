 class TimeslotsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_timeslot, only: [:show, :edit, :update, :destroy]

  # GET /timeslots
  def index
    @timeslots = Timeslot.all
    @events = Event.where( "start_at > ?", Time.now )
  end

  # GET /timeslots/1
  def show
    @timeslot = Timeslot.find(params[:id])
  end

  # GET /timeslots/new
  def new
    @timeslot = Timeslot.new
  end

  # GET /timeslots/1/editx
  def edit
    @timeslot = Timeslot.find(params[:id])
  end

  # POST /timeslots
  def create
    @timeslot = current_user.timeslots.build(timeslot_params)

    if @timeslot.save
      redirect_to @timeslot, notice: 'Timeslot was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /timeslots/1
  def update
    if @timeslot.update(timeslot_params)
      @timeslot = Timeslot.find(params[:id])
      @event = Event.create(usrid: @timeslot.user_id, start_at: @timeslot.start_at, end_at: @timeslot.end_at, name: @timeslot.name)
      @timeslot.destroy
      redirect_to timeslots_path, notice: 'Timeslot was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /timeslots/1
  def destroy
    @timeslot.destroy
    redirect_to timeslots_url, notice: 'Timeslot was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timeslot
      @timeslot = Timeslot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def timeslot_params
      params.require(:timeslot).permit(:name, :user_id, :start_at, :end_at)
    end
end
