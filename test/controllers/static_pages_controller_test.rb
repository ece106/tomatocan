

require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
   get :home
   assert_response :success
  end

  test 'should_get_aboutus' do
    get :getinvolved
    assert_response :success
  end

  test 'should_get_drschaeferspeaking' do
    get :drschaeferspeaking
    assert_response :success
  end

  test 'should_get_jointheteam' do
    get :jointheteam
    assert_response :success
  end

  test 'should_get_studyhall' do
    get :studyhall
    assert_response :success
  end

  test 'should_get_faq' do
    get :faq
    assert_response :success
  end

  test 'should_get_tos' do
    get :tos
    assert_response :success
  end

    test 'should_get_bystanderguidelines' do
    get :bystanderguidelines
    assert_response :success
  end

  test 'should_get_livestream' do
    get :livestream
    assert_response :success
  end

  test 'should_get_vieweronhost' do
    get :vieweronhost
    assert_response :success
  end

  # test "correct_head" do
  # get :home
  # assert_select 'title', "ThinQ.tv"
  # end
end