require 'test_helper'
require 'capybara-screenshot/minitest'
require 'selenium-webdriver'
@driver = Selenium::WebDriver.for :firefox
@driver.navigate.to 'http://localhost:3000/'
class EventsTest < ActionDispatch::IntegrationTest
include Capybara::DSL
include Capybara::Minitest::Assertions
Capybara::Screenshot.autosave_on_failure = false# disable screenshot on failure
@driver = Selenium::WebDriver.for :firefox

 setup do
   Capybara.server = :webrick
   Capybara.default_driver = :selenium_headless
   @driver.navigate.to 'http://localhost:3000'
 end
end
