class Movie < ApplicationRecord
  has_many :movieroles
  belongs_to :user

  mount_uploader :moviepic, MoviepicUploader

  validates :title, presence: true
  validates :about, length: { maximum: 2000 }
  validates :user_id, presence: true
end
