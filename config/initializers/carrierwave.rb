require 'carrierwave/storage/fog'
#Excon.defaults[:write_timeout] = 1000
#  Excon.defaults = Excon.defaults.mere(:write_timeout => 10.minutes.to_i)

if Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
#    config.storage = :file
#    config.root = "#{Rails.root}/tmp"
#    config.cache_dir = "#{Rails.root}/tmp/images"
    config.storage = :fog
    config.fog_credentials = { 
      :provider               => 'AWS',
      :aws_access_key_id      => AWS_KEY,
      :aws_secret_access_key  => AWS_SECRET_KEY, 
      :persistent             => false,
      :region             => 'us-west-1'
    }
    config.permissions = 0777
    config.fog_directory  = AWS_BUCKET
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end
end
  
if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    =  :aws                  # required
    config.aws_bucket =  ENV['AWS_BUCKET']      # required
    config.aws_acl    =  :public_read
    
  
    config.aws_credentials = {
      access_key_id:      ENV['AWS_KEY'],       # required
      secret_access_key:  ENV['AWS_SECRET_KEY'],
      :region => 'us-east-1'
    }
    
  end
end