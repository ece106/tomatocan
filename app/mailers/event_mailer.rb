class EventMailer < ApplicationMailer
  before_action do
    @recipient = params[:recipient]
    @event = params[:event]
    @user = params[:user]
  end
  def new_event
    @url = event_url(host:'crowdpublish.TV', id: @user.id)
    mail(to: @recipient.email, subject: "Someone you follow has created an event")
  end
end
