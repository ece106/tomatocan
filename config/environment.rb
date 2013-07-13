# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Crowdpublishtv::Application.initialize!

#for debugging before push to heroku
#ENV['RAILS_ENV'] ||= 'production'
#rails server -e production