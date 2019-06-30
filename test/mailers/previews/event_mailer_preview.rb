# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  def new_event
    EventMailer.with(user: User.first, event: Event.first_or_create, recipient: User.last).new_event
  end
  def event_reminder
    event = Event.create(start_at:(Time.now + 3.days))
    EventMailer.with(user: User.first, event: event).event_reminder
  end
end
