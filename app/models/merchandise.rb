class Merchandise < ApplicationRecord

  belongs_to :user
  has_many :purchases
  validates :price, presence: true
  mount_uploader :itempic, MerchpicUploader
  mount_uploader :podcast, PodcastUploader
  mount_uploader :video, VideoUploader
  mount_uploader :graphic, GraphicUploader
#  mount_uploader :pdf, PdfUploader  # need to change column names for these
#  mount_uploader :epub, EpubUploader
#  mount_uploader :mobi, MobiUploader

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
