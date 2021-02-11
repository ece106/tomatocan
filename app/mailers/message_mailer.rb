class MessageMailer < ApplicationMailer

  before_action do
    @message = params[:message]
  end

  def message_reminder
    mail(to: "lisa@thinq.tv", subject: "Message from Thinq.TV site")
  end

end