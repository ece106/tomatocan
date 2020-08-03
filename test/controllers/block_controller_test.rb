require 'test_helper'
class BlockControllerTest < ActionController::TestCase
    include ActiveJob::TestHelper

  setup do 
    @user = users :one
    @blocked_user = users :two
    post :block, params: {to_block: @blocked_user.id, owner: @user.id}
  end

  #block
  test 'blockedBy_not_empty' do
    #post :block, params: {to_block: @blocked_user.id, owner: @user.id}
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

  test 'BlockedUsers_array_has_correct_count_after_block' do
     blockedUsers = User.find_by_id(@user.id).BlockedUsers
     assert_equal blockedUsers.count, 1
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

  #unload
  



  #is_blocked



  #signedin?
end
