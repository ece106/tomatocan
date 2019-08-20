require_relative 'boot'

require 'rails/all'

if defined?(Bundler) # do we need this in rails 5?
   # If you precompile assets before deploying to production, use this line
   Bundler.require *Rails.groups(:assets => %w(development test))
   # If you want your assets lazily compiled in production, use this line
   # Bundler.require(:default, :assets, Rails.env)
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Crowdpublishtv
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
      # Enable the asset pipeline
    config.assets.enabled = true
#    Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
    config.assets.paths << "#{Rails.root}/app/assets/video"
  end
end
