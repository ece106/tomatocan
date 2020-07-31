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
      event = Event.find(params[:rsvpq][:event_id])
      offset = -1 * Time.now.in_time_zone("Pacific Time (US & Canada)").gmt_offset/3600
      reminder_date = event.start_at + offset.hours - 1.hours #why is the scope Instance instead of local??? Where else is this needed?
      email = params[:rsvpq][:email] #why is the scope Instance instead of local??? Where else is this needed?
      if current_user
        RsvpMailer.with(user: current_user, event: event, timeZone: params[:timeZone]).rsvp_reminder.deliver_later(wait_until: reminder_date)
      else
        RsvpMailer.with(email: email, event: event, timeZone: params[:timeZone]).rsvp_reminder.deliver_later(wait_until: reminder_date)
      end
      redirect_back(fallback_location: request)
    else
      rsvp = Rsvpq.find_by(email: @rsvp.email)
      if rsvp.nil?
        flash[:error] = 'Please enter a valid email address'
      else
        flash[:error] = 'Entered email already has an rsvp for this event'
      end
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
