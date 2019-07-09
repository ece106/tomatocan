class RsvpqMailerPreview < ActionMailer::Preview

  def rsvpq_created
    rsvpq_mailer_hash = { rsvpq: Rsvpq.first_or_create, user: User.first, event: Event.first_or_create }
    RsvpqMailer.with(rsvpq_mailer_hash).rsvpq_created
  end

end
