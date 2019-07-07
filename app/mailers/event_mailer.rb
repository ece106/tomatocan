class EventMailer < ApplicationMailer

  before_action do 
    @event = params[:event]
    @user = params[:user]
  end

  before_action :set_url , only: [:event_reminder]
  before_action :format_date, only: [:event_reminder]

  def event_reminder
    mail(to: @user.email, subject: "A reminder for your event on #{@date_subject_format}")
  end

 private

  def set_url
    @event_url = event_url(host:'crowdpublish.TV', id: @user.id)
    @share_url = tellfriends_url(host: 'crowdpublish.TV')
  end

  def format_date
    @start_date = Time.parse(@event.start_at.to_s)
    @date_subject_format = @start_date.strftime('%m/%d/%Y')
    @date_body_format = @start_date.strftime('%m/%d/%Y at %I:%M %p')
  end
end
