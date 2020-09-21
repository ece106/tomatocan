Devise.setup do |config|
   config.secret_key = ENV['DEVISE_SECRET_KEY']
#  config.mailer_sender = 'thinQtvStaff@gmail.com'
   config.mailer_sender = '"ThinQ tv" <info@ThinQ.tv>'
   require 'devise/orm/active_record'
   config.case_insensitive_keys = [ :email ]
   config.strip_whitespace_keys = [ :email ]
   config.skip_session_storage = [:http_auth]
   config.stretches = Rails.env.test? ? 1 : 10
   config.reconfirmable = true
   config.password_length = 8..128
   config.reset_password_within = 6.hours
   config.sign_out_via = :delete
   config.omniauth_path_prefix = "/users/auth"
   if Rails.env.production?
      config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], callback_url: "https://thinq.tv/users/auth/facebook/callback"
      config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], callback_url: "https://thinq.tv/users/auth/google_oauth2/callback"
   else
      config.omniauth :facebook, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, callback_url: "http://localhost:3000/users/auth/facebook/callback"
      config.omniauth :google_oauth2, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, callback_url: "http://localhost:3000/users/auth/google_oauth2/callback"
   end
end