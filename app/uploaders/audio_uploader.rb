class AudioUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  if Rails.env.development? || Rails.env.test?
    #storage :file  # but what if I want to test fog/aws
    storage :file
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
    %w(mp3 wav m4a)
  end

end