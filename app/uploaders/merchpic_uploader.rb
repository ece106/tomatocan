# encoding: utf-8

class MerchpicUploader < CarrierWave::Uploader::Base
#  include CarrierWave::RMagick
#  include CarrierWave::MiniMagick
#  process crop: :itempic
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  if Rails.env.development? || Rails.env.test?
    storage :file  # but what if I want to test fog/aws
  else
    storage :fog
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def extension_whitelist
    %w(jpg jpeg gif png tif)
  end

end
