class RsvpqsController < ApplicationController
  before_action :set_rsvp, only: [:show, :update]
#  before_action :authenticate_user!
  layout :resolve_layout

  # GET /rsvps/1
  def show
#    :update
  end

  # POST /rsvps
  def create
    if current_user
      @rsvp = current_user.rsvpqs.build(rsvpq_params)
    else
      @rsvp = Rsvpq.new(rsvpq_params)
    end

    if @rsvp.save
      flash[:success] = 'Rsvp was successfully created.'
      redirect_to home_path
    else
      flash[:error] = 'Please enter a valid email address'
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
