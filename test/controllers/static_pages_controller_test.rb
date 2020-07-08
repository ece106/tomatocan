

require 'test_helper'

#test working as of 07/08/2020
#
class StaticPagesControllerTest < ActionController::TestCase
  # test "should get home" do
  #  get :home
  #  assert_response :success
  # end

  test 'should_get_aboutus' do
    get :getinvolved
    assert_response :success
  end

  test 'should_get_have_us_on_your_podcast' do
    get :drschaeferspeaking
    assert_response :success
  end

  test 'should_get_faq' do
    get :faq
    assert_response :success
  end


  test 'should_get_join_us' do
    get :jointheteam
    assert_response :success
  end

  test 'should_get_study_hall' do
    get :studyhall
    assert_response :success
  end


  test 'should_get_tos' do
    get :tos
    assert_response :success
  end

  # test "correct_head" do
  # get :home
  # assert_select 'title', "ThinQ.tv"
  # end
end
