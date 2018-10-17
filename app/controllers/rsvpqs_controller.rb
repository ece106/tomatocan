class RsvpqsController < ApplicationController
  before_action :set_rsvp, only: [:show, :edit, :update, :destroy]
  #before_action :authenticate_user!
  layout :resolve_layout

  # GET /rsvps
  def index
    @rsvps = Rsvpq.all
  end

  # GET /rsvps/1
  def show
#    :update
  end

  # GET /rsvps/new
  def new
    @rsvp = Rsvpq.new
  end

  # GET /rsvps/1/edit
  def edit
  end

  # POST /rsvps
  def create
    if current_user
      @rsvp = current_user.rsvpqs.build(rsvpq_params)
    else
      @rsvp = Rsvpq.new(rsvpq_params)
      @rsvp.user_id = "guest"

    end

    if @rsvp.save
      redirect_to home_path notice: 'Rsvp was successfully created.'
    else
#      @rsvp.errors.add(:email, "Email not valid")
      redirect_back(fallback_location: root_path)
      
    end
  end

  # PATCH/PUT /rsvps/1
  def update
    if @rsvp.update(rsvpq_params)
      redirect_to @rsvp, notice: 'Rsvp was successfully updated.'
    else
      render action: 'edit'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rsvp
      @rsvp = Rsvpq.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rsvpq_params
      params.require(:rsvpq).permit(:event_id, :user_id, :guests, :email)
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
