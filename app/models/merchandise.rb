class Merchandise < ApplicationRecord
  belongs_to :user
  has_many :purchases

  validates :price, presence: true, numericality: true

  validates :name, presence: true

  validates :buttontype, presence: true, inclusion: { in: ["Buy","Donate"]}


  mount_uploader :itempic, MerchpicUploader
  mount_uploader :audio, AudioUploader
  mount_uploader :video, VideoUploader
  mount_uploader :graphic, GraphicUploader
  mount_uploader :merchepub, MerchepubUploader
  mount_uploader :merchmobi, MerchmobiUploader
  mount_uploader :merchpdf, MerchpdfUploader

  def get_filename_and_data
    filename_and_data = {}
    self.attributes.each do  |name, value|
      if name == 'audio' and value != nil
        filename_and_data = {filename: value, data: audio}
      end
      if name == 'graphic' and value != nil
        filename_and_data = {filename: value, data: graphic}
      end
      if name == 'video' and value != nil
        filename_and_data = {filename: value, data: video}
      end
      if name == 'merchpdf' and value != nil
        filename_and_data = {filename: value, data: merchpdf}    
      end
      if name == 'merchmobi' and value != nil
        filename_and_data = {filename: value, data: merchmobi}
      end
      if name == 'merchepub' and value != nil
        filename_and_data = {filename: value, data: merchepub}
      end
    end
    filename_and_data
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
