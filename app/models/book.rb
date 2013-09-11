class Book < ActiveRecord::Base
  attr_accessible :bookmobi, :bookepub, :bookkobo, :coverpicurl, :title, :blurb, :releasedate, :genre, :price, :fiftychar, :user_id, :bookpdf, :coverpic
  belongs_to :user
#  has_many :purchases
  has_many :reviews

  validates :fiftychar, length: { maximum: 140 }
  validates :blurb, length: { maximum: 2000 }
  validates :user_id, presence: true
  default_scope order: 'books.releasedate DESC'

  mount_uploader :bookpdf, ProfilepicUploader
  mount_uploader :bookmobi, ProfilepicUploader
  mount_uploader :bookepub, ProfilepicUploader
  mount_uploader :bookkobo, ProfilepicUploader
#  mount_uploader :image, ImageUploader
#  mount_uploader :coverpic, CoverpicUploader

end
