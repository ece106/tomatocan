class GrouppicUploader < CarrierWave::Uploader::Base

  if Rails.env.development? || Rails.env.test?
    storage :file 
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
