# encoding: utf-8

class ProfilepicUploader < CarrierWave::Uploader::Base
#  include CarrierWave::RMagick
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  if Rails.env.development? || Rails.env.test?
    storage :file  # but what if I want to test fog/aws
    #storage :fog
  else
    storage :fog
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
#    "#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_whitelist
    %w(jpg jpeg gif png tif)
  end

end
