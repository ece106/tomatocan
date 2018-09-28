OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '540047143115663', '855f1430a73b498b160ab845b36e7de4', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}}}
end