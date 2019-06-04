##DON'T DELETE THIS FILE YET. CURRENTLY, THIS FILE CAUSES ISSUES WHEN RUNNING rails test, SUCH AS BREAKING USERS INTEGRATION TESTS. WILL SEE IF FIXABLE.
# require 'test_helper'
# require 'capybara-screenshot/minitest'
# require 'selenium-webdriver'
# # options = Selenium::WebDriver::Chrome::Options.new
# # options.add_argument('--headless')
# # driver = Selenium::WebDriver.for :chrome, options: options

# #driver=Selenium::WebDriver.for :chrome


# class UsersTest < ActionDispatch::IntegrationTest
# 	include Capybara::DSL
# 	include Capybara::Minitest::Assertions
# 	Capybara::Screenshot.autosave_on_failure = false# disable screenshot on failure
#     @driver = Selenium::WebDriver.for :chrome
# 	@driver.navigate.to 'http://localhost:3000'

# 	setup do
# 	   Capybara.server = :webrick
# 	   Capybara.default_driver = :selenium_headless
# 	   #@driver.navigate.to 'http://localhost:3000'
# 	end
# 	def goto()
# 	   @driver.navigate.to 'http://localhost:3000'
# 	end
# 	def signupSelenium()
# 	    @driver.navigate.to 'http://localhost:3000'
# 	end
# 	def signup()
# 	  visit ('/')
# 	  click_on('Sign Up', match: :first)
# 	  fill_in(id:'user_name', with: 'name')
# 	  fill_in(id:'user_email', with: 'e@gmail.com')
# 	  fill_in(id:'user_permalink', with:'username')
# 	  fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
# 	  fill_in(id:'user_password_confirmation', with:'password')
# 	  click_on(class: 'form-control btn-primary')#Click Signup
# 	  #is user sent to their profile info page?
# 	end
# 	def signIn()
# 	  visit('/')
# 	  click_on('Sign In', match: :first)
# 	  fill_in(id: 'user_email', with: 'e@gmail.com')
# 	  fill_in(id: 'user_password', with: 'password')
# 	  click_on(class: 'form-control btn-primary')
# 	end
# 	test "Should_signup" do
# 		visit('http://localhost:3000')
# 		signup()
# 		assert expect(page).to have_selector("input[value='name']")
# 	end
# end
