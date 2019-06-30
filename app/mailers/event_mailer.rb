class EventMailer < ApplicationMailer
  before_action do
    @recipient = params[:recipient]
    @event = params[:event]
    @user = params[:user]
  end

  before_action :set_url , only: [:new_event]
  before_action :format_date, only: [:event_reminder]

  def new_event
    mail(to: @recipient.email, subject: "Someone you follow has created an event")
  end

  def event_reminder
    mail(to: @user.email, subject: "A reminder for your event on #{@date_of_event}")
  end

 private

  def set_url
    @url = event_url(host:'crowdpublish.TV', id: @user.id)
  end

  def format_date
    @date_of_event = Time.strptime(@event.start_at.to_s,'%x')
  end
end