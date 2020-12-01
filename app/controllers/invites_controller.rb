class InvitesController < ApplicationController

  # GET /invites/new  
  def new
    if current_user.nil?
      redirect_to "/invite_error"
    end
    @invite = Invite.new
  end

  # GET /invite/:referer_id
  def invite_received
    id = params[:referer_id]
    create_referer_cookie(id)
    # redirect to homepage
    redirect_to home_path
  end

  def create_referer_cookie( id )
    # The if statement checks for valid integer in String format.
    if id.to_i.to_s == id
      # create cookie
      cookies[:referer_id] = {
        value: id,
        expires: 1.month.from_now
      }
    else
      raise "Error: Invalid referer_id \"" + id.to_s + "\". referer_id must be an int."
    end
  end

  # POST /invites
  def create
    if current_user == nil
      redirect_to new_invite_path, danger: "You must be signed in!"
    else
      invite_params["sender_id"] = current_user.id

      if verify_recaptcha(model: @invite)
        session[:invite_phone_number] = Invite.get_phone_number(invite_params["phone_number"], invite_params["country_code"])
        session[:invite_message] = Invite.get_message(invite_params["relationship"], invite_params["interest"], current_user.name, current_user.id)

        redirect_to new_invite_confirm_path, success: "Your invite has been crafted!" + "\nCountry Code: " + invite_params["country_code"] + "\nPhone number: " + session[:invite_phone_number] + "\n Message:\n" + session[:invite_message]
      else
        redirect_to new_invite_path, danger: "Please check the captcha box!"
      end
    end
  end

  def confirm
    @editNumber = session[:invite_phone_number]
    @editMessage = session[:invite_message]
  end

  def edit
  end

  private
    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :interest, :sender_id)
    end

end
