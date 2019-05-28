require 'test_helper'
require 'capybara-screenshot/minitest'
class EventsTest < ActionDispatch::IntegrationTest
 include Capybara::DSL
 include Capybara::Minitest::Assertions
 Capybara::Screenshot.autosave_on_failure = false# disable screenshot on failure
  setup do
    visit ('/')#user is at the home page by default
  end

  def ()
  end

  test " " do
  end

end