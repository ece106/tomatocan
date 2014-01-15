Crowdpublishtv::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  #config.action_mailer.smtp_settings = {
  #  :address   => "smtp.mandrillapp.com",
  #  :port      => 25, # ports 587 and 2525 are also supported with STARTTLS
  #  :enable_starttls_auto => true, # detects and uses STARTTLS
  #  :user_name => "MANDRILL_USERNAME",
  #  :password  => "MANDRILL_PASSWORD", # SMTP password is any valid API key
  #  :authentication => 'login', # Mandrill supports 'plain' or 'login'
  #  :domain => 'www.crowdpublish.tv', # your domain to identify your server when connecting
  #}

  config.action_mailer.default_url_options = { :host => 'localhost: 
3000', :protocol => 'http' } 
  #config.action_mailer.delivery_method = :smtp 
  config.action_mailer.smtp_settings = { 
    :enable_starttls_auto => true, 
    :address => 'localhost', 
    :port => '1025', 
    :authentication => :plain, 
   # :domain => 'www.crowdpublish.tv', 
   # :user_name => 'lschaeferaz@hotmail.com', 
   # :password => '?' 
  } 

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end
