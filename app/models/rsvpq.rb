class Rsvpq < ApplicationRecord
  belongs_to :user , :optional => true
  belongs_to :event
#  validates :user_id, presence: true
  validates :event_id, presence: true
  validates_format_of :email, with: Devise.email_regexp
end
