class RsvpMailer < ApplicationMailer

    before_action do
        @event = params[:event]
        @user = params[:user]
    end

    before_action :set_url , only: [:rsvp_reminder]
    before_action :format_date, only: [:rsvp_reminder]

    def rsvp_reminder
        inline_images
        mail(to: @user.email, subject: "A reminder for your ThinQ.tv Conversation on #{@date_subject_format}")
    end

    private

    def inline_images
        img_path ="app/assets/images/social-share-button"
        img_list = ['email.png','facebook.png','linkedin.png','twitter.png']
        img_list.each {|x| attachments.inline[x] = File.read("#{img_path}/#{x}")}
        attachments.inline['starIcon.png'] = File.read("app/assets/images/starIcon.png")
    end

    def set_url
        @event_url = event_url(host:'ThinQ.tv', id: @event.id)
    end

    def format_date
        @start_date = Time.parse(@event.start_at.to_s)
        @date_subject_format = @start_date.strftime('%m/%d/%Y')
        @date_body_format = @start_date.strftime('%m/%d/%Y at %I:%M %p')
    end
end
  