require 'time'
class EventMailer < ApplicationMailer
  before_action do
    @recipient = params[:recipient]
    @event = params[:event]
    @user = params[:user]
  end

  before_action :set_url , only: [:new_event,:event_reminder]
  before_action :format_date, only: [:event_reminder]

  def new_event
    mail(to: @recipient.email, subject: "Someone you follow has created an event")
  end

  def event_reminder
    mail(to: @user.email, subject: "A reminder for your event on #{@date_subject_format}")
  end

 private

  def set_url
    @url = event_url(host:'crowdpublish.TV', id: @user.id)
  end

  def format_date
    @start_date = Time.parse(@event.start_at.to_s)
    @date_subject_format = @start_date.strftime('%d/%m/%Y')
  end
end