class Event < ActiveRecord::Base
  has_event_calendar
#  belongs_to :user
  has_many :rsvpqs
  has_many :users, :through => :rsvpqs
  validates :usrid, presence: true
  validates :name, presence: true

  validates :name, format: { without: /http|\.co|\.com|\.org|\.net|\.tv|\.uk|\.ly|\.me|\.biz|\.mobi|\.cn|kickstarter|barnesandnoble|smashwords|itunes|amazon|eventbrite|rsvpify|evite|meetup/i, message: "s 
    ...URLs are not allowed in event titles. Keep in mind that people will be searching here for actual gatherings 
    that they can attend, or to find out when you'll be livestreaming. They will not be searching for sites to 
    browse." }
  validates :desc, format: { without: /http|\.co|\.com|\.org|\.net|\.tv|\.uk|\.ly|\.me|\.biz|\.mobi|\.cn|kickstarter|barnesandnoble|smashwords|itunes|amazon|eventbrite|rsvpify|evite|meetup/i, message: "riptions 
    ...URLs are not allowed in event descriptions. Keep in mind that people will be searching here for actual 
    gatherings that they can attend, or to find out when you'll be livestreaming. They will not be searching for 
    sites to browse. Paste all information attendees need here." }
  validates :address, format: { without: /http|\.co|\.com|\.org|\.net|\.tv|\.uk|\.ly|\.me|\.biz|\.mobi|\.cn|kickstarter|barnesandnoble|smashwords|itunes|amazon|eventbrite|rsvpify|evite|meetup/i, message: " 
    ...URLs are not allowed in addresses. Events are searchable only by street address & zip code. If you will be 
    livestreaming this event from www.CrowdPublish.TV/yourpage/stream, leave the address as the default: livestream " }

  validates_numericality_of :end_at, :less_than => Proc.new { |r| r.start_at.to_f + 3.days.to_f }, :allow_blank => true, message: " date can't be more than 3 days after Event start date"
  validates_numericality_of :end_at, :greater_than => Proc.new { |r| r.start_at.to_f }, :allow_blank => true, message: " time must be after Event start time"
  geocoded_by :address

  after_initialize :assign_defaults_on_new_event, if: 'new_record?'
  after_validation :geocode, :if => :address_changed?

  private
  def assign_defaults_on_new_event
    self.address = "livestream" unless self.address
  end

end
