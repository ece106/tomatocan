Devise.setup do |config|
   config.secret_key = 'DEVISE_SECRET_KEY'
#   config.secret_key = ENV['DEVISE_SECRET_KEY']  #I'm not convinced heroku uses this. Locally, rails s won't start if above line is not set. But heroku doesn't choke if this line isn't set.
#   config.mailer_sender = 'thinQtvStaff@gmail.com'
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
   config.omniauth_path_prefix = '/users/auth'
   config.omniauth :facebook, "566814783947187", "841733b04b92defa62fde1b29f0da0ac", callback_url: "https://localhost:3000/users/auth/facebook/callback"
   #callback_url: "https://boiling-reef-18462.herokuapp.com/users/auth/facebook/callback"
end