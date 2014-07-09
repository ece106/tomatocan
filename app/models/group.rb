class Group < ActiveRecord::Base
    belongs_to :user
    validates :user_id, presence: true
    geocoded_by :address
    after_validation :geocode, :if => :address_changed?
end
