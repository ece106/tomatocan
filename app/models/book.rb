class Book < ActiveRecord::Base
  attr_accessible :coverpicurl, :title, :blurb, :releasedate, :genre, :price, :fiftychar, :user_id, :bookpdf, :coverpic
  belongs_to :user
#  has_many :purchases

  validates :user_id, presence: true
  default_scope order: 'books.releasedate DESC'

#  mount_uploader :bookpdf, BookpdfUploader
#  mount_uploader :image, ImageUploader
#  mount_uploader :coverpic, CoverpicUploader

end
