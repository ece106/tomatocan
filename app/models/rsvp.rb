class Rsvp < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :user_id, presence: true
  validates :event_id, presence: true
end
