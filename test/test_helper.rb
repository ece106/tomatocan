ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'fileutils'
require 'carrierwave/storage/fog'
require 'capybara/rails'
require 'capybara/minitest'
require 'selenium-webdriver'
require 'simplecov'
require './test/test_helper'

#Simple cov used to generate a coverage report
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/' # for rspec
  add_filter '/test/' # for minitest
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions
  fixtures :all
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @card_number           = "4242424242424242"
    @cvc                   = "123"
  end

  def user_sign_in  user
   visit root_path 
   click_on class: 'btn btn-default'
   fill_in id: 'user_email',    with:  "#{user.email}"
   fill_in id: 'user_password', with:  "user1234"
   click_on class: 'form-control btn-primary'
  end

  def card_information_entry 
    fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
    fill_in id: 'card_number',          with: "#{@card_number}"
    fill_in id: 'card_code',            with: "#{@cvc}"
    select 'August',                    from: 'card_month'
    select '2024',                      from: 'card_year'
  end

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

class ActionMailer::TestCase
  fixtures :all
end

class ActiveSupport::TestCase
  fixtures :all
  # Carrierwave setup and teardown
  carrierwave_template = Rails.root.join('test','fixtures','files')
  carrierwave_root = Rails.root.join('test','support','carrierwave')

  # Carrierwave configuration is set here instead of in initializer
  CarrierWave.configure do |config|
    config.root = carrierwave_root
    config.enable_processing = false
    config.storage = :file
    config.cache_dir = Rails.root.join('test','support','carrierwave','carrierwave_cache')
    # config.fog_credentials = {
    #   :provider               => 'AWS',
    #   :aws_access_key_id      => AWS_KEY,
    #   :aws_secret_access_key  => AWS_SECRET_KEY,
    #   :persistent             => false,
    #   :region             => 'us-east-1'
    # }
    # config.storage = :fog
    # config.permissions = 0777
    # config.fog_directory  = 'authorprofile1'
    # config.fog_public     = true
    # config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
  end

  # And copy carrierwave template in
  #puts "Copying\n  #{carrierwave_template.join('uploads').to_s} to\n  #{carrierwave_root.to_s}"
  FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root

  at_exit do
    #puts "Removing carrierwave test directories:"
    Dir.glob(carrierwave_root.join('*')).each do |dir|
      #puts "   #{dir}"
      FileUtils.remove_entry(dir)
    end
  end

  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password    = options[:password]    || 'user123'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = 1 # user.id
    end
  end

  private

  # Returns true inside an integration test.
  def integration_test?
    defined?(post_via_redirect)

  end
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end
