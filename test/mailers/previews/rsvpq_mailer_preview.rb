class RsvpqMailerPreview < ActionMailer::Preview

  def rsvpq_created
    rsvpq_mailer_hash = { rsvpq: Rsvpq.find_by(event_id: 4), user: User.first }
    RsvpqMailer.with(rsvpq_mailer_hash).rsvpq_created
  end

end
