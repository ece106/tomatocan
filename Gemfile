source 'http://rubygems.org'
ruby "1.9.3"

gem 'pg'
gem 'mandrill'	
gem 'devise', '~> 3.2.4'
gem 'fog'   #, '1.6.0'
gem 'unf' 
gem 'carrierwave'
gem 'stripe'
#gem "debugger-pry", :require => "debugger/pry"
gem 'aws-s3'
gem 'aws-sdk'
gem 'event-calendar', :require => 'event_calendar'

gem 'rails', '4.0.2'
gem  'bootstrap-sass', '2.3.2.0'
gem "will_paginate", "~> 3.0.4" 
# Use ActiveModel has_secure_password
#gem 'bcrypt-ruby', '~> 3.1.2'
gem 'bcrypt'
gem 'turbolinks'
gem 'jquery-turbolinks'
#gem "paperclip", "~> 2.0"
#gem 'rmagick'

group :development, :test do
#  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :production do
# rake db:create:all
# rails s -e production
#  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rails_12factor'
end

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Gems used only for assets and not required
# in production environments by default.
#group :assets do
gem 'sass-rails', '~> 4.0.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
#end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
