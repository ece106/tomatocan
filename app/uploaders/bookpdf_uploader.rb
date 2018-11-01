# encoding: utf-8

class BookpdfUploader < CarrierWave::Uploader::Base

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

  def extension_white_list
    %w(pdf)
  end


end
