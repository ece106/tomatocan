class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  before_save { |group| group.permalink = permalink.downcase }

  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :grouptype, presence: true
  validates :permalink, presence: true, format: { with: /\A[\w+]+\z/ }, length: { maximum: 20 },
                uniqueness: { case_sensitive: false }

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

#  mount_uploader :profilepic, ProfilepicUploader

end
