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
      redirect_to new_invite_path, danger: "You must be signed in!"
    else
      invite_params["sender_id"] = current_user.id

      if verify_recaptcha(model: @invite)
        @@globalNum = get_phone_number
        @@globalMessage = get_message

        redirect_to new_invite_confirm_path, success: "Your invite has been crafted!"
      else
        redirect_to new_invite_path, danger: "Please check the captcha box!"
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
      params.require(:invite).permit(:phone_number, :country_code, :relationship, :interest, :preferred_name, :sender_id)
    end

    def get_phone_number
      countryAb = invite_params["country_code"]
      countryCode = IsoCountryCodes.find(countryAb).calling
      phoneNum = invite_params["phone_number"]
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

    def get_message
      # All messages begin with the standard line below.
      messageBody = "ThinQ.tv invite from " + current_user.name.titleize + ":\n"
      relation = enumerate_relationship(invite_params["relationship"])

      case invite_params["interest"]
        when "Career Advice"
          if relation < 2 then
            messageBody += "Looking for advice on navigating your STEM career? Try attending one of our live mentors' consultation hours at ThinQ.tv for free!\n" + get_invite_url
          else
            messageBody += "A STEM video chat community where people in their early career can get live advice from mentors and peers. Join ThinQ.tv today!\n" + get_invite_url
          end
        when "Finding STEM Employers"
          if relation < 3 then
            messageBody += "Jump-start your STEM career by networking with employers and chatting with mentors live at ThinQ.tv!\n" + get_invite_url
          else
            messageBody += "Are you looking for STEM employers and mentors? Join a live conversation for free today at ThinQ.tv!\n" + get_invite_url
          end
        when "Finding Employment at Thinq"
          if relation < 2 then
            messageBody += "Interested in working on web design or video conferencing software? Apply to ThinQ.tv today!\n" + get_invite_url
          else
            messageBody += "Are you interested in finding employment as a Web Developer or User Experience Engineer? Apply to ThinQ.tv today!\n" + get_invite_url
          end
        when "STEMinism"
          messageBody += "Connect with a video chat community of powerful women role models in STEM who inspire you to ThinQ!\n" + get_invite_url
        when "Inclusivity in STEM"
          messageBody += "ThinQ.tv, a community building a better future for women and minorities in STEM. Join today for free!\n" + get_invite_url
        else # "(Decline to Specify)"
          case relation
            when 0 # Family
              messageBody += invite_params["preferred_name"] + ", come check out \n" + get_invite_url + "\nto get tips from industry pros, and host good conversations!"
            when 1 # Friends
              messageBody += "Hey "+ invite_params["preferred_name"] + ", come check out\n" + get_invite_url + "\nand get tips from industry pros!"
            when 2 # General Acquaintances
              messageBody += "Hi " + invite_params["preferred_name"] + ", " + current_user.name.titleize + " has invited you to join ThinQ. Sign up at \n" + get_invite_url + "\nto get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
            when 3 # Coworkers
              messageBody += "Hi " + invite_params["preferred_name"] + ", based on your work experience and ties, " + current_user.name + " has invited you to join ThinQ.tv!\nSign up at " + get_invite_url + "\nto get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
            else
              # Site users should never see this. I'm storing the alternate suggestion for the generic message here.
              messageBody += "Change your world one conversation at a time with ThinQ.tv!\n" + get_invite_url
          end
      end
      return messageBody
    end

end
