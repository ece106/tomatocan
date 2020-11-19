class InvitesController < ApplicationController

  @@globalNum = 0
  @@globalMessage = "blank"

  # GET /invites/new  
  def new
    @invite = Invite.new
  end

  # GET /invite/:referer_id
  def invite_received
    # create cookie
    cookies[:referer_id] = {
      value: params[:referer_id],
      expires: 1.month.from_now
    }
    # trigger redirect
    redirect_to home_path
  end

  # POST /invites
  def create
    if current_user == nil
      redirect_to new_invite_path, danger: invite_error_message + "You must be signed in!"
    else

      invite_params["sender_id"] = current_user.id

      if verify_recaptcha(model: @invite)

        countryAb = invite_params["country_code"]
        countryCode = IsoCountryCodes.find(countryAb).calling
        phoneNum = invite_params["phone_number"]
        completeNum = countryCode + phoneNum
        @@globalNum = completeNum

        messageBody = ""

        case invite_params["relationship"]
          when "Friends"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + "!: %0D%0AHey, " + invite_params["preferred_name"] + ", come check out%0D%0A %0D%0Ahttps://thinq.tv/invite/" + current_user.id.to_s + "%0D%0A%0D%0Aand get tips from industry pros!"
          when "Family"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0A" + invite_params["preferred_name"] + ", come check out %0D%0A%0D%0Ahttps://thinq.tv/invite/" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and host good conversations!"
          when "Coworkers"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + "," + " based on your work experience and ties, " + current_user.name + " has invited you to join ThinQ. %0D%0A%0D%0ASign up at https://thinq.tv/invite/" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
          when "General Acquaintances"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + ", " + current_user.name.titleize + " has invited you to join ThinQ. Sign up at %0D%0A%0D%0Ahttps://thinq.tv/invite/" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          else
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + ", " + current_user.name.titleize + " has invited you to join ThinQ. Sign up at %0D%0A%0D%0Ahttps://thinq.tv/invite/" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
        end

        @@globalMessage = messageBody

        redirect_to new_invite_confirm_path, success: invite_error_message + "Your invite has been crafted!"
  
      else
        redirect_to new_invite_path, danger: invite_error_message + "Please check the captcha box!"
      end
    end
  end

  def confirm
    @editNumber = @@globalNum
    @editMessage = @@globalMessage
  end

  def edit
  end


  private
    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :preferred_name, :sender_id)
    end
end

