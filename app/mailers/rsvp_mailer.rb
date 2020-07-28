class RsvpMailer < ApplicationMailer

    before_action do
        @event = params[:event]
        @user = params[:user]
        @email = params[:email]
        @time = params[:timeZone]
    end

    before_action :set_url , only: [:rsvp_reminder]
    before_action :format_content, only: [:rsvp_reminder]

    def rsvp_reminder
        inline_images
        if @user.nil?
            mail(to: @email, subject: "A reminder for your ThinQ.tv Conversation on #{@date_subject_format}")
        else
            mail(to: @user.email, subject: "A reminder for your ThinQ.tv Conversation on #{@date_subject_format}")
        end
    end

    private

    def inline_images
        img_path ="app/assets/images/social-share-button"
        img_list = ['email.png','facebook.png','linkedin.png','twitter.png']
        img_list.each {|x| attachments.inline[x] = File.read("#{img_path}/#{x}")}
        attachments.inline['logoDigitalHollow300.png'] = File.read("app/assets/images/logoDigitalHollow300.png")
    end

    def set_url
        @event_url = event_url(host:'ThinQ.tv', id: @event.id)
        @user_url = "https://thinq.tv" + "/" + User.find(@event.user_id).permalink + "/viewer"
        @share_url = "https://thinq.tv"
    end

    def format_content
        @start_date = Time.parse(@event.start_at.to_s)
        @date_subject_format = @start_date.strftime('%m/%d/%Y')
        @date_body_format = @start_date.strftime('%m/%d/%Y at ')
        @event_owner = User.find(@event.user_id).name
        @share_message = %W{
                                #{@event_owner} is hosting a video conversation today at #{@time}. Come join us for a fun, thought
                                provoking video conversation.
                            }.join(' ')
        @share_email_subject = "Invitation to Participate"
        @share_email_content = %W{
                                Hey!\nJoin me at #{@user_url} today at #{@time}. #{@event_owner} is hosting a 
                                live video conversation titled "#{@event.name}" and I would be glad to have you participate.
                                
                                Here's a brief description of what it's about:\n #{@event.desc.to_s.truncate_words(15)}\n
                                Thank you.
                            }.join(' ')
    end

end
  