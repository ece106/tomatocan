class EventMailer < ApplicationMailer

  self.delivery_job = SendEventReminderJob

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
    @home_url = event_url(host:'crowdpublish.TV', id: @user.id)
    @share_url = tellfriends_url(host: 'crowdpublish.TV')
  end

  def format_date
    @start_date = Time.parse(@event.start_at.to_s)
    @date_subject_format = @start_date.strftime('%m/%d/%Y')
    @date_body_format = @start_date.strftime('%m/%d/%Y at %I:%M %p')
  end
end
