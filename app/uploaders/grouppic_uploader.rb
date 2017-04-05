class GrouppicUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

   def extension_white_list
     %w(jpg jpeg gif png tif)
   end
end
