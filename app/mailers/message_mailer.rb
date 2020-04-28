class MessageMailer < ApplicationMailer

  before_action do
    @message = params[:message]
  end

  def message_reminder
    mail(to: "lisa@thinq.tv", subject: "A new Invite for Dr Lisa to speak")
  end

end