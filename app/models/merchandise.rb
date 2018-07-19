class Merchandise < ApplicationRecord

  attr_accessor :rttoeditphase 

  belongs_to :user 
  belongs_to :phase, optional: true
  has_many :purchases
  validates :price, presence: true
  mount_uploader :itempic, MerchpicUploader

end
