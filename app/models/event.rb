class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :user
  validates :user_id, presence: true
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
