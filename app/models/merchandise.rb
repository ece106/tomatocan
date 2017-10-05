class Merchandise < ActiveRecord::Base

  attr_accessor :rttoeditphase 

  belongs_to :user # the project has user_id but merch doesn't have to be part of proj
  belongs_to :project
  has_many :purchases
  mount_uploader :itempic, MerchpicUploader
  after_initialize :assign_defaults_on_new_merch, if: 'new_record?'

  private
    def assign_defaults_on_new_merch 
      self.price = 10.0 unless self.price
    end
end
