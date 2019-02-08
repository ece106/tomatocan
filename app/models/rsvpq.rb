class Rsvpq < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
#  user does not need to be signed in to make purchase
#  TODO: make check dependent on sign in status
#  validates :user_id, presence: true

   validates :event_id, presence: true
#  validates_format_of :email, with: Devise.email_regexp # May want to validate email address by sending an email to it
end
