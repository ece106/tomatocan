class Event < ActiveRecord::Base
  has_event_calendar
  has_many :rsvps
  has_many :users, :through => :rsvps
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  geocoded_by :address

  after_initialize :assign_defaults_on_new_event, if: 'new_record?'
  after_validation :geocode, :if => :address_changed?

  private
  def assign_defaults_on_new_event
    self.address = "online"
  end

end
