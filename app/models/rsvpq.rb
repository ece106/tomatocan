class Rsvpq < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
#  validates :user_id, presence: true
	validates :event_id, presence: true
	validates_format_of   :email, with: Devise.email_regexp, allow_blank: true
	
	validates_uniqueness_of :email, :message => 'Entered email already has an rsvp'

	validates :email, presence: {unless: :user_id? }

end
