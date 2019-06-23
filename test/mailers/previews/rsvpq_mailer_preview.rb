class RsvpqMailerPreview < ActionMailer::Preview

  def rsvpq_created
    RsvpqMailer.with(rsvpq: Rsvpq.find_by(event_id: 4), user: User.first).rsvpq_created
  end

end
