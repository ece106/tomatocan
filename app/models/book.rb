class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews
  has_many :purchases

  after_initialize :assign_defaults_on_new_book

  validates :title, presence: true
  validates :fiftychar, length: { maximum: 140 }
  validates :blurb, length: { maximum: 2000 }
  validates :user_id, presence: true
 # validates :price, presence: true, :format => { :with => /\A\d+??(?:\.\d{0,2})?\z/ }
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  default_scope {order('books.releasedate DESC')}

#  mount_uploader :bookkobo, ProfilepicUploader
#  mount_uploader :coverpic, CoverpicUploader
#  mount_uploader :bookpdf, BookpdfUploader
#  mount_uploader :bookmobi, BookmobiUploader
#  mount_uploader :bookepub, BookepubUploader
#  mount_uploader :bookaudio, BookaudioUploader

  private
  def assign_defaults_on_new_book
    self.price = self.price || 10.0
  end

end
