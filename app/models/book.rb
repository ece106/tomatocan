class Book < ActiveRecord::Base
#  attr_accessible :bookepub, :bookmobi, :bookkobo, :coverpicurl, :title, :blurb, :releasedate, :genre, :price, :fiftychar, :user_id, :bookpdf, :coverpic
  belongs_to :user
  has_many :reviews
  has_many :purchases

  validates :title, presence: true
  validates :fiftychar, length: { maximum: 140 }
  validates :blurb, length: { maximum: 2000 }
  validates :user_id, presence: true
  validates :price, presence: true,
            :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }
  default_scope order: 'books.releasedate DESC'

#  mount_uploader :coverpic, ProfilepicUploader
#  mount_uploader :bookpdf, ProfilepicUploader
#  mount_uploader :bookmobi, ProfilepicUploader
#  mount_uploader :bookepub, ProfilepicUploader
#  mount_uploader :bookkobo, ProfilepicUploader
  mount_uploader :coverpic, CoverpicUploader
  mount_uploader :bookpdf, BookpdfUploader
  mount_uploader :bookmobi, BookmobiUploader
  mount_uploader :bookepub, BookepubUploader
  mount_uploader :bookkobo, BookkoboUploader

end
