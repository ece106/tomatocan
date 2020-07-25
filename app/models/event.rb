class Event < ApplicationRecord

  serialize :recurring, Hash

  has_many :rsvpqs
  has_many :users, through: :rsvpqs

  validates :start_at, uniqueness: { scope: :topic, message: "Can't have simultaneous Conversations/Activism Halls" }
  validates :user_id, presence: true

  validates :name, presence: true
  validates :start_at, presence: true
  validates :name, format: { without: /http|\.co|\.com|\.org|\.net|\.tv|\.uk|\.ly|\.me|\.biz|\.mobi|\.cn|kickstarter|barnesandnoble|smashwords|itunes|amazon|eventbrite|rsvpify|evite|meetup/i, message: "s
    ...URLs are not allowed in event titles. Keep in mind that people will be searching here for ThinQtv Conversations. They will not be searching for sites to
    browse." }
  validates :desc, format: { without: /http|\.co|\.com|\.org|\.net|\.tv|\.uk|\.ly|\.me|\.biz|\.mobi|\.cn|kickstarter|barnesandnoble|smashwords|itunes|amazon|eventbrite|rsvpify|evite|meetup/i, message: "descriptions
    ...URLs are not allowed in event descriptions. Keep in mind that people will be searching here for ThinQtv Conversations. They will not be searching for
    sites to browse. Paste all information attendees need here." }

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



  def recurring=(value)
    if value != "null"
      super(RecurringSelect.dirty_hash_to_rule(value).to_hash)
    else
      super(nil)
    end
  end

  def rule
    IceCube::Rule.from_hash recurring
  end

  def schedule(start)
    schedule = IceCube::Schedule.new(start)
    schedule.add_recurrence_rule(rule)
    schedule
  end

  def calendar_events(start)
    if recurring.empty?
      [self]
    else
      end_date = start.end_of_month.end_of_week
      schedule(start_at).occurrences(end_date).map do |date|
        Event.new(id: id, name: name, start_at: date, user_id: user_id, desc: desc, end_at: end_at, topic: topic)
      end
    end
  end

  def as_json(*)
    super.except.tap do |hash|
      @user = User.find(user_id)
      hash["permalink"] = @user.permalink
      hash["username"] = @user.name
    end
  end
  
end
