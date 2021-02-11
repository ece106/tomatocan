class MessagesController < ApplicationController
  def create
      @message = Message.new(message_params)
    if @message.save
      MessageMailer.with(message: @message).message_reminder.deliver_later
      flash[:success] = "Message was succesfully sent. We will get back to you via your email address shortly."
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = message_error_message
      redirect_back(fallback_location: root_path)
    end
  end
    private
    def message_params
      params.require(:message).permit(:fullname, :phone_number, :email, :subject, :message)
    end 

   def message_error_message
      msg = ""
      if @message.errors.messages[:fullname].present?
        msg += ("Fullname " + @message.errors.messages[:fullname][0] + "\n")
      end
      if @message.errors.messages[:subject].present?
        msg += ("Subject " + @message.errors.messages[:subject][0] + "\n")
      end
      if @message.errors.messages[:message].present?
        msg += ("Message " + @message.errors.messages[:message][0] + "\n")
      end
      if @message.errors.messages[:email].present?
        msg += ("Email " + @message.errors.messages[:email][0] + "\n")
      end
      return msg
    end
end