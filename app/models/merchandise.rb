class Merchandise < ApplicationRecord

  attr_accessor :rttoeditphase 

  belongs_to :user 
  belongs_to :phase, optional: true
  has_many :purchases
  mount_uploader :itempic, MerchpicUploader

end
