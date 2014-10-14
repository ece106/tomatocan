class Group < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :name, presence: true
  validates :permalink, presence: true, length: { maximum: 20 },
                    format:     { with: /\A[\w+]+\z/ },
                    uniqueness: { case_sensitive: false }

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

#  mount_uploader :profilepic, ProfilepicUploader

end
