require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "Should view profileinfo" do
  	get '/supportourwork'
  	assert_select 'h1', 'Discussion Hosts'
  end
end
