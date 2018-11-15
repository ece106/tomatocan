class MerchmobiUploader < CarrierWave::Uploader::Base

  if Rails.env.development? || Rails.env.test?
    storage :file  # but what if I want to test fog/aws
  else
    storage :fog
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
#    "#{model.class.to_s.underscore}/#{model.id}"
#    "#{User.id}/#{model.id}"
  end

  def extension_whitelist
    %w(mobi)
  end

end
