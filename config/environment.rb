#ActionMailer::Base.delivery_method = :smtp #if needed later: failing our tests

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
