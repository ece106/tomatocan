class RsvpqsController < ApplicationController
  before_action :set_rsvp, only: [:show, :update]

  # before_action :authenticate_user!
  layout :resolve_layout

  def show
  end

  def create
    if current_user
      @rsvp = current_user.rsvpqs.build(rsvpq_params)
    else
      @rsvp = Rsvpq.new(rsvpq_params)
    end

    if @rsvp.save
      flash[:success] = 'Rsvp was successfully created.'

      rsvpq_mailer_hash = { rsvpq: @rsvp, user: current_user }
      RsvpqMailer.with(rsvpq_mailer_hash).rsvpq_created.deliver_later

      redirect_to home_path
    else
      flash[:error] = 'Please enter a valid email address'
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    if @rsvp.update(rsvpq_params)
      flash[:notice] = 'Rsvp was successfully updated.'
      redirect_to @rsvp
    else
      render action: 'edit'
    end
  end

  private

  def set_rsvp
    @rsvp = Rsvpq.find(params[:id])
  end

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
