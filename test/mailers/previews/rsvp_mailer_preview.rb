# Preview all emails at http://localhost:3000/rails/mailers/rsvp_mailer
class RsvpMailerPreview < ActionMailer::Preview
    def rsvp_reminder
        @event = Event.find(1) # input event number
        RsvpMailer.with(user: User.first, event: @event).rsvp_reminder
    end
end