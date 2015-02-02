class RsvpsController < ApplicationController
  before_action :set_rsvp, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user! 
  layout :resolve_layout

  # GET /rsvps
  def index
    @rsvps = Rsvp.all
  end

  # GET /rsvps/1
  def show
#    :update
  end

  # GET /rsvps/new
  def new
    @rsvp = Rsvp.new
  end

  # GET /rsvps/1/edit
  def edit
  end

  # POST /rsvps
  def create
    @rsvp = current_user.rsvps.build(rsvp_params)

    if @rsvp.save
      redirect_to events_path notice: 'Rsvp was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /rsvps/1
  def update
    if @rsvp.update(rsvp_params)
      redirect_to @rsvp, notice: 'Rsvp was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /rsvps/1
  def destroy
    @rsvp.destroy
    redirect_to rsvps_url, notice: 'Rsvp was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rsvp
      @rsvp = Rsvp.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rsvp_params
      params.require(:rsvp).permit(:event_id, :user_id, :guests)
    end

    def resolve_layout
      case action_name
      when "index"
        'application'
      else
        'application'
      end
    end


end
