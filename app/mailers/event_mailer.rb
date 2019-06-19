class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.new_event.subject
  #
  def new_event(recipient, event, user)
    @recipient = recipient
    @event = event
    @url = event_url(host:'crowdpublish.TV', id: user.id)
    @user = user
    mail(to: @recipient.email, subject: "Somone you follow has created an event")
  end
end
