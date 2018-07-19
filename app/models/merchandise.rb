class Merchandise < ApplicationRecord

  attr_accessor :rttoeditphase 

  belongs_to :user 
  belongs_to :phase, optional: true
  has_many :purchases
  validates :price, presence: true
  mount_uploader :itempic, MerchpicUploader

  private
    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end
end
