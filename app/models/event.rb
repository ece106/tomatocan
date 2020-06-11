class Event < ApplicationRecord
  has_many :rsvpqs
  has_many :users, through: :rsvpqs
  validates :start_at, uniqueness: { scope: [:topic] }
  validates :usrid, presence: true
  validates :name, presence: true
  validates :start_at, presence: true
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
    livestreaming this event from www.ThinQ.tv/yourpage/stream, leave the address as the default: livestream " }

  scope :recent,   -> { order(:start_at, :desc) }
  scope :upcoming, -> { where('start_at > ?', Time.now) }

  time = Proc.new { |r| r.start_at.to_f + 3.hours.to_f } #what the hell is this variable for

  validates_numericality_of :end_at, less_than: ->(t) { (t.start_at.to_f + 5.hours.to_f) }, allow_blank: true, message: " time can't be more than 3 hours after Conversation start time"

=begin
  validate :endat_greaterthan_startat
  def endat_greaterthan_startat
    #start_at.present? added for testing purpuoses (Absence throws nil comparasion during testing)
    #It is redundant otherwise since validates rule already avoids this issue
    if end_at.present? && start_at.present? && end_at < start_at
      errors.add(:end_at, "End time must be after start time")
    end
  end
=end

  def as_json(*)
    super.except.tap do |hash|
      @user = User.find(usrid)
      hash["permalink"] = @user.permalink
      hash["username"] = @user.name
    end
  end

end
