require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserNavbar < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser

    user_sign_in @test_user

    visit new_event_path
  end

  test 'navitem buttons and sign out' do
    assert page.has_css? '.nav-item'
    assert page.has_link? 'Home'
    first(:xpath, "//a[@href='/']").click
    assert_equal '/', current_path
    assert page.has_link? 'About Us'
    find_link('About Us', match: :first).click
    first(:xpath, "//a[@href='/getinvolved']").click
    assert page.has_link? 'Join the Team'
    first(:xpath, "//a[@href='/jointheteam']").click
    assert_equal '/jointheteam', current_path
    assert page.has_link? 'Drop in Anytime'
    first(:xpath, "//a[@href='/studyhall']").click
    assert_equal '/studyhall', current_path

    #sign out
    click_on class: 'btn btn-primary border-warning text-warning', match: :first
    assert '/', current_path
  end

  test 'view profile page and logout' do
    # assert text, "#{@user.name}"
    assert page.has_css? '.dropdown'
    assert page.has_css? '.dropdown-menu'
    assert page.has_link? 'View Profile'
    find_link('View Profile',match: :first).click
    assert_equal "/#{@test_user.permalink}", current_path
    click_on class: 'btn btn-primary border-warning text-warning', match: :first

    assert '/', current_path
  end

  test 'view control panel page and logout' do
    # assert text, "#{@user.name}"
    assert page.has_css? '.dropdown'
    assert page.has_css? '.dropdown-menu'
    assert page.has_link? 'Control Panel'
    find_link('Control Panel',match: :first).click
    assert_equal "/#{@test_user.permalink}/controlpanel", current_path
    click_on class: 'btn btn-primary border-warning text-warning', match: :first

    assert '/', current_path
  end

  private
  def teardown
  end
end
