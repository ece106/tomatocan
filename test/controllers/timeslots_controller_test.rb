require 'test_helper'

class TimeslotsControllerTest < ActionController::TestCase
  setup do
    @timeslot = timeslots(:one)
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create timeslot" do
  #   sign_in users(:one)
  #   assert_difference('Timeslot.count', 1) do
  #     post :create, params: { timeslot: { end_at: @timeslot.end_at, start_at: @timeslot.start_at, user_id: @timeslot.user_id } }
  #   end

  #   assert_redirected_to timeslot_url(Timeslot.last)
  # end

  # test "should show timeslot" do
  #   get timeslot_url(@timeslot)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_timeslot_url(@timeslot)
  #   assert_response :success
  # end

  # test "should update timeslot" do
  #   patch timeslot_url(@timeslot), params: { timeslot: { end_at: @timeslot.end_at, start_at: @timeslot.start_at, user_id: @timeslot.user_id } }
  #   assert_redirected_to timeslot_url(@timeslot)
  # end

  # test "should destroy timeslot" do
  #   assert_difference('Timeslot.count', -1) do
  #     delete timeslot_url(@timeslot)
  #   end
  #   assert_redirected_to timeslots_url
  # end


end
