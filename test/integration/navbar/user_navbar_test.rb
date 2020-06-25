require "test_helper"
require "capybara-screenshot/minitest"
require "pry"

class UserNavbar < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @confirmedUser = users :confirmedUser

    visit root_path

  end
  
  feature 'navitem buttons and logout' do
    assert page.has_css? '.nav-item'
    assert page.has_link? 'Home'
    find_link('Home', match: :first).click
    assert_equal '/', current_path
    assert page.has_link? 'Discover Previous Conversations'
    find_link('Discover Previous Conversations', match: :first).click
    assert_equal '/supportourwork', current_path
    assert page.has_link? 'Invite Us To Speak'
    find_link('Invite Us To Speak', match: :first).click
    assert_equal '/drschaeferspeaking', current_path
    assert page.has_link? 'Be a ThinQtv Influencer!'
    find_link('Be a ThinQtv Influencer!', match: :first).click
    assert_equal '/internship', current_path
    assert page.has_link? 'FAQ'
    find_link('FAQ', match: :first).click
    assert_equal '/faq', current_path
    click_on class: 'btn btn-default', match: :first

    assert '/', current_path
  end
  
  test 'view profile page and logout' do
    assert text, "#{@confirmedUser.name}"
    assert page.has_css? '.dropdown'
    assert page.has_css? '.dropdown-toggle'
    find(class: 'dropdown',match: :first).click

    assert page.has_link? 'View Profile'
    find_link('View Profile',match: :first).click
    assert_equal "/#{@confirmedUser.permalink}", current_path
    click_on class: 'btn btn-default', match: :first

    assert '/', current_path
  end

  test 'view control panel and confirm navbar elements' do
    user_sign_in @confirmedUser
    assert text, "#{@confirmedUser.name}"
    find(class: 'dropdown-toggle', match: :first).click
    click_on('Control Panel', match: :first)
    assert_equal "/#{@confirmedUser.permalink}/controlpanel", current_path
  end

  test 'view control panel page and logout' do
    assert text, "#{@confirmedUser.name}"
    assert page.has_css? '.dropdown'
    assert page.has_css? '.dropdown-toggle'
    find(class: 'dropdown-toggle',match: :first).click

    assert page.has_link? 'Control Panel'
    find_link('Control Panel',match: :first).click
    assert_equal "/#{@confirmedUser.permalink}/controlpanel", current_path
    click_on class: 'btn btn-default', match: :first

    assert '/', current_path
  end
  
  private

  def teardown
  end
end
