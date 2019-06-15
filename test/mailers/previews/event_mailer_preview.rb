# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/new_event

  def new_event
    EventMailer.new_event(User.first, Event.first_or_create, User.last)
  end

end
