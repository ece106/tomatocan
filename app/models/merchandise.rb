class Merchandise < ApplicationRecord

  belongs_to :user
  has_many :purchases

  validates :price, presence: true
  validates :name, presence: true
  validates :buttontype, presence: true
  validates_numericality_of :price

  mount_uploader :itempic, MerchpicUploader
  mount_uploader :audio, AudioUploader
  mount_uploader :video, VideoUploader
  mount_uploader :graphic, GraphicUploader
  mount_uploader :merchepub, MerchepubUploader
  mount_uploader :merchmobi, MerchmobiUploader
  mount_uploader :merchpdf, MerchpdfUploader

  attr_accessor :itempic_crop_x, :itempic_crop_y, :itempic_crop_w, :itempic_crop_h
  after_update :crop_itempic

  def get_non_empty_attachments 
    merchandise_attachments = {}
    self.attributes.each do  |name, value|
      case name
      when 'audio'
        merchandise_attachments['audio'] = value
      when 'graphic' 
        merchandise_attachments['graphic'] = value
      when 'video'
        merchandise_attachments['video'] = value
      when 'merchpdf' 
        merchandise_attachments['merchpdf'] = value
      when 'merchmobi'
        merchandise_attachments['merchmobi'] = value
      when 'merchepub'
        merchandise_attachments['merchepub'] = value
      end
    end
    merchandise_attachments
  end

  def crop_itempic
    itempic.recreate_versions! if itempic_crop_x.present?
  end

  def get_youtube_id
    if self.youtube.present?
      if self.youtube.match(/youtube.com/) || self.youtube.match(/youtu.be/)
        youtubeparsed = parse_youtube self.youtube
        self.update_attribute(:youtube, youtubeparsed)
      end
    end
  end

  private
    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end
    

end
