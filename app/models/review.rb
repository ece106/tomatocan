class Review < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true

  belongs_to :book
  validates :book_id, presence: true

  validates :blurb, presence: true
end
