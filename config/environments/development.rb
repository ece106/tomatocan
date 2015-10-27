Crowdpublishtv::Application.configure do
  
config.action_mailer.smtp_settings = {
   :address   => "smtp.gmail.com",
   :port      => 587, # ports 587 and 2525 are also supported with STARTTLS
   :enable_starttls_auto => true, # detects and uses STARTTLS
   :user_name => "crowdpublishtv.star@gmail.com",
   :password  => 'GMAIL_PWD', # SMTP password is any valid API key
   :authentication => 'plain', # Mandrill supports 'plain' or 'login'
   :domain => 'www.crowdpublish.tv', # your domain to identify your server when connecting
 }

config.action_mailer.default_url_options = {
  :host => 'localhost:3000', :protocol => 'http' 
}

  config.cache_classes = false

  config.eager_load = false    #needed for version upgrade rails 4, ruby1.9.3

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers 
  config.action_dispatch.best_standards_support = :builtin  #Is it needed in rails 4?

  # Do not compress assets
  config.assets.compress = false   #Is it needed in rails 4?

  # Expands the lines which load the assets
  config.assets.debug = true
 # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load # good for upgrade rails 4?

end

  