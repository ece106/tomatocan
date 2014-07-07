class Event < ActiveRecord::Base
  has_event_calendar
  
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
