require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserNavbar < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit new_event_path
  end

  test 'footer links' do
    assert page.has_link? 'FAQ'
    first(:xpath, "//a[@href='/faq']").click
    assert_equal '/faq', current_path

    assert page.has_link? 'Invite Us To Speak'
    first(:xpath, "//a[@href='/drschaeferspeaking']").click
    assert_equal '/drschaeferspeaking', current_path

    assert page.has_link? 'Terms of Service'
    first(:xpath, "//a[@href='/tos']").click
    assert_equal '/tos', current_path

    assert page.has_link? 'Privacy Policy'
    first(:xpath, "//a[@href='/studyhall']").click
    assert_equal '/studyhall', current_path
  end

  private
  def teardown
  end
end
