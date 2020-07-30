require 'test_helper'
class BlockControllerTest < ActionController::TestCase
    include ActiveJob::TestHelper

  setup do 
    @user = users(:one)
    @blocked_user = users(:two)
    @user_to_unblock = users(:three)
  end

  #block
  test 'convo_owner_added_to_blockedBy_array' do
    
  end
      
  test 'blocked_user_added_to_BlockedUsers_array' do

  end

  #test 'already_blocked_user_not_reblocked'

  #unblock
  #test 'unblocked_user_removed_from_BlockedUsers_array'

  #test 'convo_owner_removed_from_blockedBy_array'

  #unload
  



  #is_blocked



  #signedin?

