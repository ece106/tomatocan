class Invite

    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :phone_number, :country_code, :relationship, :interest, :sender_id

    validates :phone_number, :presence => true

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  
    def persisted?
      false
    end



  def Invite.get_phone_number(phone_number, country_code)
    countryAb = country_code
    countryCode = IsoCountryCodes.find(countryAb).calling
    return countryCode + phone_number
  end

  def Invite.get_invite_url(id_number)
    "https://thinq.tv/invite/" + id_number.to_s
  end

  def Invite.enumerate_relationship(relationship)
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

  def Invite.get_message( relationship, interest, current_username, id_number )
    # All messages begin with the standard line below.
    messageBody = "ThinQ.tv invite from " + current_username.titleize + ": %0D%0A"
    relation = Invite.enumerate_relationship(relationship)

    case interest.downcase
      when "career advice"
        if relation < 2 then
          messageBody += "Looking for advice on navigating your STEM career? Try attending one of our live mentors' consultation hours at ThinQ.tv for free!%0D%0A" + Invite.get_invite_url(id_number)
        else
          messageBody += "A STEM video chat community where people in their early career can get live advice from mentors and peers. Join ThinQ.tv today!%0D%0A" + Invite.get_invite_url(id_number)
        end
      when "finding stem employers"
        if relation < 3 then
          messageBody += "Jump-start your STEM career by networking with employers and chatting with mentors live at ThinQ.tv!%0D%0A" + Invite.get_invite_url(id_number)
        else
          messageBody += "Are you looking for STEM employers and mentors? Join a live conversation for free today at ThinQ.tv!%0D%0A" + Invite.get_invite_url(id_number)
        end
      when "finding employment at thinq"
        if relation < 2 then
          messageBody += "Interested in working on web design or video conferencing software? Apply to ThinQ.tv today!%0D%0A" + Invite.get_invite_url(id_number)
        else
          messageBody += "Are you interested in finding employment as a Web Developer or User Experience Engineer? Apply to ThinQ.tv today!%0D%0A" + Invite.get_invite_url(id_number)
        end
      when "steminism"
        messageBody += "Connect with a video chat community of powerful women role models in STEM who inspire you to ThinQ!%0D%0A" + Invite.get_invite_url(id_number)
      when "inclusivity in stem"
        messageBody += "ThinQ.tv, a community building a better future for women and minorities in STEM. Join today for free!%0D%0A" + Invite.get_invite_url(id_number)
      else # "I'm unsure"
        case relation
          when 0 # Family
            messageBody += "Come check out %0D%0A" + Invite.get_invite_url(id_number) + "%0D%0Ato get tips from industry pros, and host good conversations!"
          when 1 # Friends
            messageBody += "Come check out %0D%0A" + Invite.get_invite_url(id_number) + "%0D%0Aand get tips from industry pros!"
          when 2 # General Acquaintances
            messageBody += current_username.titleize + " has invited you to join ThinQ. Sign up at %0D%0A" + Invite.get_invite_url(id_number) + "%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations!"
          when 3 # Coworkers
            messageBody += "Based on your work experience and ties, " + current_username + " has invited you to join ThinQ.tv!%0D%0ASign up at " + Invite.get_invite_url(id_number) + "%0D%0Ato get tips from industry pros, and share your own knowledge in hosted thoughtful conversations."
          else
            # Site users should never see this. I'm storing the alternate suggestion for the generic message here.
            messageBody += "Change your world one conversation at a time with ThinQ.tv!%0D%0A" + Invite.get_invite_url(id_number)
        end
    end
    return messageBody
  end

  end
