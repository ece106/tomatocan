require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class NonuserNavbar < ActionDispatch::IntegrationTest
  setup do
    @user = {name: "fake_name", email: "newfake@fake.com", permalink: "fake_user",
       password: "fake_password", password_confirmation: "fake_password"}
    @confirmedUser = users :confirmedUser
    visit root_path
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
end
