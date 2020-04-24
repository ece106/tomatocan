class RsvpMailer < ApplicationMailer

    before_action do
        @event = params[:event]
        @user = params[:user]
        @email = params[:email]
        @zone = params[:timeZone]
    end

    before_action :set_url , only: [:rsvp_reminder]
    before_action :format_content, only: [:rsvp_reminder]

    def rsvp_reminder
        inline_images
        if @user.nil?
            mail(to: @email, subject: "A reminder for your ThinQ.tv Conversation on #{@date_subject_format}")
        else
            mail(to: @user.email, subjct: "A reminder for your ThinQ.tv Conversation on #{@date_subject_format}")
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
        @user_link = "https://thinqtv.herokuapp.com/" + User.find(@event.usrid).permalink
    end

    def format_content
        @start_date = Time.parse(@event.start_at.to_s)
        @date_subject_format = @start_date.strftime('%m/%d/%Y')
        @date_body_format = @start_date.strftime('%m/%d/%Y at ')
        @share_message = "Join us at ThinQ.tv and participate in thought-provoking video conversations about books, current events, and trivia games!"
        @share_email_subject = "Join me at ThinQ.tv"
        @event_owner = User.find(@event.usrid).name
    end

end
  