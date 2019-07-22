# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  def event_reminder
    event = Event.create(start_at: DateTime.now, name: 'event in 3 days')
    EventMailer.with(user: User.first, event: event).event_reminder
  end
end
