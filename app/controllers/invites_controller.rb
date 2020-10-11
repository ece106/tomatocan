class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  # GET /invites
  def index
    @invites = Invite.all
  end

  # GET /invites/1
  def show
  end

  # GET /invites/new
  def new
    @invite = Invite.new
  end

  # GET /invites/1/edit
  def edit
  end

  # POST /invites
  def create
      @invite = Invite.new(invite_params)
  
        if verify_recaptcha(model: @invite) && @invite.save
          account_sid = "AC40d4b5f21aef08a190398e6383f76a41"
          auth_token = "c36b559ca5d28821328513b5438c48fb"
  
          countryAb = invite_params["country_code"]
          countryCode = IsoCountryCodes.find(countryAb).calling
          phoneNum = invite_params["phone_number"]
          completeNum = countryCode + phoneNum

          messageBody = ""

          case invite_params["relationship"]
          when "Friends"
            messageBody = "ThinQ.tv Invite from " + current_user.name + "!: Hey, " + invite_params["preferred_name"] + ", come check out https://thinq.tv/signup/" + current_user.id.to_s + " and get tips from industry pros!"
          when "Family"
            messageBody = "ThinQ.tv Invite from " + current_user.name + ": " + invite_params["preferred_name"] + ", come check out https://thinq.tv/signup/" + current_user.id.to_s + " to get tips from industry pros, and host good conversations!"
          when "Coworkers"
            messageBody = "ThinQ.tv Invite from " + current_user.name + ": Hi " + invite_params["preferred_name"] + "," + " based on your work experience and ties, " + current_user.name + " has invited you to join ThinQ. Sign up at https://thinq.tv/signup/" + current_user.id.to_s + " to get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
          when "General Acquaintances"
            messageBody = "ThinQ.tv Invite from " + current_user.name + ": Hi " + invite_params["preferred_name"] + "," + current_user.name + " has invited you to join ThinQ. Sign up at https://thinq.tv/signup/" + current_user.id.to_s + " to get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          else
            messageBody = "ThinQ.tv Invite from " + current_user.name + ": Hi " + invite_params["preferred_name"] + "," + current_user.name + " has invited you to join ThinQ. Sign up at https://thinq.tv/signup/" + current_user.id.to_s + " to get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          end
  
          @client = Twilio::REST::Client.new(account_sid, auth_token)
          @client.messages.create(
                  to: completeNum,
                  from: "+16026930976",
                  body: messageBody
              )
          result = ""
          redirect_to new_invite_success_path, success: invite_error_message + "Your invite has been sent!"
        else
          redirect_to new_invite_form_path, danger: invite_error_message + "Please check the captcha box!"
        end
    end

  # DELETE /invites/1
  def destroy
    @invite.destroy
    redirect_to invites_url, notice: 'Invite was successfully destroyed.'
  end

  def invite_error_message
    msg = ""
    return msg
  end

  # Messages Sent:
  # def invite_friend(name)
  #   msg = name + " Friend msg"
  #   return msg
  # end

  # def invite_family_member
  #   msg = "Fam msg"
  #   return msg
  # end

  # def invite_coworker
  #   msg = "work msg"
  #   return msg
  # end

  # def invite_acquaintance
  #   msg = "gen msg"
  #   return msg
  # end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :preferred_name)
    end
end
