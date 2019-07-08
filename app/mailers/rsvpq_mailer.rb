class RsvpqMailer < ApplicationMailer

  before_action do
    @rsvpq = params[:rsvpq]
    @user  = params[:user]
  end

  before_action :set_url, only: [:rsvpq_created]

  default to: -> { @user.email }

  def rsvpq_created
    mail subject: "Successfully created an RSVP."
  end

  private

  def set_url
    @url = event_url(host:'localhost:3000', id: @rsvpq.event_id)
  end

end
