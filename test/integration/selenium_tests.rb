#require 'test_helper'
#require 'capybara-screenshot/minitest'
#require 'selenium-webdriver'
##define driver for firefox webdriver
##Capybara::Selenium::Driver.new( :browser => :chrome, :driver_path => '74.0.3729.6')
##@driver = Selenium::WebDriver::firefox.driver_path = 'firefdriver'
##driver = driver.new( :browser => :chrome, :driver_path => 'chromedriver')
#
#
##driver=Selenium::WebDriver.for :chrome
#
#
#class EventsTest < ActionDispatch::IntegrationTest
# include Capybara::DSL
# include Capybara::Minitest::Assertions
# Capybara::Screenshot.autosave_on_failure = false# disable screenshot on failure
# @driver = Selenium::WebDriver.for :firefox
#
#  setup do
#    Capybara.server = :webrick
#    Capybara.default_driver = :selenium_headless
#     @driver.navigate.to 'http://localhost:3000'
#  end
#def goto()
#    @driver.navigate.to 'http://localhost:3000'
#end
#  def signupSelenium()
#      @driver.navigate.to 'http://localhost:3000'
#  end
#  def signup()
#    visit ('/')
#    click_on('Sign Up', match: :first)
#    fill_in(id:'user_name', with: 'name')
#    fill_in(id:'user_email', with: 'e@gmail.com')
#    fill_in(id:'user_permalink', with:'username')
#    fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
#    fill_in(id:'user_password_confirmation', with:'password')
#    click_on(class: 'form-control btn-primary')#Click Signup
#    assert_text ('Profile Image')#is user sent to their profile info page?
#    visit ('/')
#  end
#  def signIn()
#    visit('/')
#    click_on('Sign In', match: :first)
#    fill_in(id: 'user_email', with: 'e@gmail.com')
#    fill_in(id: 'user_password', with: 'password')
#    click_on(class: 'form-control btn-primary')
#  end
#  def createReward()
#    signup()
#    click_on('name')
#    click_on('Control Panel')
#    click_on('Rewards')
#    click_on(class: 'btn btn-lg btn-warning', match: :first)
#    fill_in(id: 'merchandise_name', with: 'Shoe')
#    fill_in(id: 'merchandise_price', with: '5')
#    fill_in(id: 'merchandise_desc', with: 'this is a description')
#    click_on(class: 'btn btn-lg btn-primary')
#  end
#  def createEvent()
#    signup()
#    click_on('Host A Show')
#    fill_in(id:'event_name', with: 'Intern')
#    fill_in(id:'event_desc', with: 'This is a description of the event')
#    click_button(class: 'btn btn-lg btn-primary')
#    assert_text('Intern')#does the event show up on the homepage?
#  end
#  test "create an event" do
#      Capybara.server = :webrick
#      Capybara.default_driver = :selenium_headless
#     createEvent()
#      assert_text('Intern')
#  end
#  test "signup with selenium" do
#       @driver.navigate.to 'http://localhost:3000'
#       goto()
#       assert_text('ddkjnjnjnikkb')
#  end
#end
#
#

