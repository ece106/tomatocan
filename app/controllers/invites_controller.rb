class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  @@globalNum = 0
  @@globalMessage = "blank"

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
    @editNumber = @@globalNum
    @editMessage = @@globalMessage
    # respond_to do |format|
    #   format.html { redirect_to "sms:#{@@globalNum}&amp;body= I%27d%20like%20to%20set%20up%20an%20appointment%20for..."} #, flash[:success] = "holder updated")
    #   format.js
    # end


    # redirect_to "sms:#{@@globalNum}&amp;body= I%27d%20like%20to%20set%20up%20an%20appointment%20for..."

  end

  # POST /invites
  def create
      if current_user == nil
        redirect_to new_invite_form_path, danger: invite_error_message + "You must be signed in!"
      else

      invite_params["sender_id"] = current_user.id
      @invite = Invite.new(invite_params)

  
        if verify_recaptcha(model: @invite) && @invite.save
          account_sid = ENV['TWILIO_ACCOUNT_SID']
          auth_token = ENV['TWILIO_ACCOUNT_TOKEN']
  
          countryAb = invite_params["country_code"]
          countryCode = IsoCountryCodes.find(countryAb).calling
          phoneNum = invite_params["phone_number"]
          completeNum = countryCode + phoneNum
          @@globalNum = completeNum

          messageBody = ""

          case invite_params["relationship"]
          when "Friends"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + "!: %0D%0AHey, " + invite_params["preferred_name"] + ", come check out%0D%0A %0D%0Ahttps://thinq.tv/signup/?referer=" + current_user.id.to_s + "%0D%0A%0D%0Aand get tips from industry pros!"
          when "Family"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0A" + invite_params["preferred_name"] + ", come check out %0D%0A%0D%0Ahttps://thinq.tv/signup/?referer=" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and host good conversations!"
          when "Coworkers"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + "," + " based on your work experience and ties, " + current_user.name + " has invited you to join ThinQ. %0D%0A%0D%0ASign up at https://thinq.tv/signup/?referer=" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
          when "General Acquaintances"
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + ", " + current_user.name.titleize + " has invited you to join ThinQ. Sign up at %0D%0A%0D%0Ahttps://thinq.tv/signup/?referer=" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          else
            messageBody = "ThinQ.tv Invite from " + current_user.name.titleize + ": %0D%0AHi " + invite_params["preferred_name"] + ", " + current_user.name.titleize + " has invited you to join ThinQ. Sign up at %0D%0A%0D%0Ahttps://thinq.tv/signup/?referer=" + current_user.id.to_s + " %0D%0A%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          end

          @@globalMessage = messageBody
          # format.html do
          #   redirect_to "sms:+19175740753&amp;body= I%27d%20like%20to%20set%20up%20an%20appointment%20for...", notice: "PO already has RR with RR ID: void RR first.".html_safe
          # end
          redirect_to new_invite_confirm_path, success: invite_error_message + "Your invite has been crafted!"
  
          # @client = Twilio::REST::Client.new(account_sid, auth_token)
          # @client.messages.create(
          #         to: completeNum,
          #         from: "+16026930976",
          #         body: messageBody
          #     )
          # result = ""
          # redirect_to new_invite_success_path, success: invite_error_message + "Your invite has been sent!"
        else
          redirect_to new_invite_form_path, danger: invite_error_message + "Please check the captcha box!"
        end
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
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :preferred_name, :sender_id)
    end
end

