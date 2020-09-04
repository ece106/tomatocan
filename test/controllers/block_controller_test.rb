require 'test_helper'
class BlockControllerTest < ActionController::TestCase
    include ActiveJob::TestHelper

  setup do 
    @user = users :one
    @blocked_user = users :two
    @event = events :one
    array = @blocked_user.last_viewed
    array.push(@event)
    @blocked_user.update({'last_viewed': array})
    Attendance.new(:user_id => @blocked_user.id, :event_id => @event.id, :time_in => (Time.now - 7.hours)).save
    post :block, params: {to_block: @blocked_user.id, owner: @user.id}
  end

  #block
  test 'blockedBy_not_empty' do
    assert_not_empty User.find_by_id(@blocked_user.id).blockedBy
  end

  test 'block_response_ok' do
    assert_response :ok
  end

  test 'convo_owner_added_to_blockedBy_array' do
    blockedBy = User.find_by_id(@blocked_user.id).blockedBy
    assert_includes blockedBy, @user.permalink
  end
      
  test 'blocked_user_added_to_BlockedUsers_array' do
    blockedUsers = User.find_by_id(@user.id).BlockedUsers
    assert_includes blockedUsers, @blocked_user.permalink
  end

  test 'already_blocked_user_not_reblocked' do
    post :block, params: {to_block: @blocked_user.id, owner: @user.id}
    blockedUsers = User.find_by_id(@user.id).BlockedUsers
    assert_not_equal blockedUsers[1], @blocked_user.permalink
    assert_equal blockedUsers.count, 1
  end

  test 'arrays_have_correct_count_after_block' do
     blockedUsers = User.find_by_id(@user.id).BlockedUsers
     blockedBy = User.find_by_id(@blocked_user.id).blockedBy
     assert_equal blockedUsers.count, 1
     assert_equal blockedBy.count, 1
  end

  #unblock
  test 'unblocked_user_removed_from_BlockedUsers_array' do
    blockedUsers = User.find_by_id(@user.id).BlockedUsers
    assert_includes blockedUsers, @blocked_user.permalink
    
    post :unblock, params: {to_unblock_id: @blocked_user.id, current_user_id: @user.id}
    blockedUsers = User.find_by_id(@user.id).BlockedUsers
    assert_not_includes blockedUsers, @blocked_user.permalink
  end

  test 'convo_owner_removed_from_blockedBy_array' do
    blockedBy = User.find_by_id(@blocked_user.id).blockedBy
    assert_includes blockedBy, @user.permalink
    
    post :unblock, params: {to_unblock_id: @blocked_user.id, current_user_id: @user.id}
    blockedBy = User.find_by_id(@blocked_user.id).blockedBy
    assert_not_includes blockedBy, @user.permalink
  end

  test 'arrays_have_correct_count_after_unblock' do
    post :unblock, params: {to_unblock_id: @blocked_user.id, current_user_id: @user.id}
    blockedUsers = User.find_by_id(@user.id).BlockedUsers
    blockedBy = User.find_by_id(@blocked_user.id).blockedBy
    assert_equal blockedUsers.count, 0
    assert_equal blockedBy.count, 0
  end

  #unload
  test 'unload_removes_current_event_from_last_viewed' do
    post :unload, params: {currentUser: @blocked_user.id, event: @event}
    last_viewed = User.find_by_id(@blocked_user.id).last_viewed
    assert_not_includes last_viewed, @event 
  end


  #is_blocked
  test 'is_blocked_response_is_permalink_of_user_who_blocked_currentuser' do
    sign_in @blocked_user
    post :is_blocked
    assert_equal(response.body, "[\""+@user.permalink+"\"]")
  end
     
  #signedin?
  test 'signedin_returns_true_if_signed_in' do
    sign_in @blocked_user
    post :signed_in?
    assert_equal(response.body, "{\"success\":true}")
  end

  #loadAttendees
  #liveCount

  # Not sure how to approach these last two methods since there aren't
  # any parameters passed to them -- should these go in integration
  # testing instead, since they seem to depend on the view?

end
