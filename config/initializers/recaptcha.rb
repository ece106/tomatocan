Recaptcha.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.site_key = RECAPTCHA_PUBLIC_KEY
    config.secret_key = RECAPTCHA_PRIVATE_KEY
  else
    config.site_key = ENV['RECAPTCHA_PUBLIC_KEY']
    config.secret_key = ENV['RECAPTCHA_PRIVATE_KEY']
  end
end
