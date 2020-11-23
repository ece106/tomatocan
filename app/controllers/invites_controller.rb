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
    # The if statement checks for valid integer in String format.
    if id.to_i.to_s == id
      # create cookie
      cookies[:referer_id] = {
        value: id,
        expires: 1.month.from_now
      }
    end
    # redirect to homepage
    redirect_to home_path
  end

  # POST /invites
  def create
    if current_user == nil
      redirect_to new_invite_path, danger: "You must be signed in!"
    else
      invite_params["sender_id"] = current_user.id

      if verify_recaptcha(model: @invite)
        session[:invite_phone_number] = get_phone_number(invite_params["phone_number"], invite_params["country_code"])
        session[:invite_message] = get_message(invite_params["relationship"], invite_params["interest"])

        redirect_to new_invite_confirm_path, success: "Your invite has been crafted!"
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

  def get_phone_number(phone_number, country_code)
    countryAb = country_code
    countryCode = IsoCountryCodes.find(countryAb).calling
    phoneNum = phone_number
    return countryCode + phoneNum
  end

  def get_invite_url
    "https://thinq.tv/invite/" + current_user.id.to_s
  end

  def enumerate_relationship(relationship)
    case relationship
      when "Family"
        return 0
      when "Friends"
        return 1
      when "General Acquaintances"
        return 2
      when "Coworkers"
        return 3
      else
        raise "Error: Unknown relationship type specified: " + relationship
    end
    return -1
  end

  def get_message( relationship, interest )
    # All messages begin with the standard line below.
    messageBody = "ThinQ.tv invite from " + current_user.name.titleize + ": %0D%0A"
    relation = enumerate_relationship(relationship)

    case interest
      when "Career Advice"
        if relation < 2 then
          messageBody += "Looking for advice on navigating your STEM career? Try attending one of our live mentors' consultation hours at ThinQ.tv for free!%0D%0A" + get_invite_url
        else
          messageBody += "A STEM video chat community where people in their early career can get live advice from mentors and peers. Join ThinQ.tv today!%0D%0A" + get_invite_url
        end
      when "Finding STEM Employers"
        if relation < 3 then
          messageBody += "Jump-start your STEM career by networking with employers and chatting with mentors live at ThinQ.tv!%0D%0A" + get_invite_url
        else
          messageBody += "Are you looking for STEM employers and mentors? Join a live conversation for free today at ThinQ.tv!%0D%0A" + get_invite_url
        end
      when "Finding Employment at Thinq"
        if relation < 2 then
          messageBody += "Interested in working on web design or video conferencing software? Apply to ThinQ.tv today!%0D%0A" + get_invite_url
        else
          messageBody += "Are you interested in finding employment as a Web Developer or User Experience Engineer? Apply to ThinQ.tv today!%0D%0A" + get_invite_url
        end
      when "STEMinism"
        messageBody += "Connect with a video chat community of powerful women role models in STEM who inspire you to ThinQ!%0D%0A" + get_invite_url
      when "Inclusivity in STEM"
        messageBody += "ThinQ.tv, a community building a better future for women and minorities in STEM. Join today for free!%0D%0A" + get_invite_url
      else # "I'm unsure"
        case relation
          when 0 # Family
            messageBody += "Come check out %0D%0A" + get_invite_url + "%0D%0Ato get tips from industry pros, and host good conversations!"
          when 1 # Friends
            messageBody += "Come check out %0D%0A" + get_invite_url + "%0D%0Aand get tips from industry pros!"
          when 2 # General Acquaintances
            messageBody += current_user.name.titleize + " has invited you to join ThinQ. Sign up at %0D%0A" + get_invite_url + "%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          when 3 # Coworkers
            messageBody += "Based on your work experience and ties, " + current_user.name + " has invited you to join ThinQ.tv!%0D%0ASign up at " + get_invite_url + "%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
          else
            # Site users should never see this. I'm storing the alternate suggestion for the generic message here.
            messageBody += "Change your world one conversation at a time with ThinQ.tv!%0D%0A" + get_invite_url
        end
    end
    return messageBody
  end

  private
    # Only allow a trusted parameter "white list" through.
    def invite_params
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :interest, :sender_id)
    end

end
