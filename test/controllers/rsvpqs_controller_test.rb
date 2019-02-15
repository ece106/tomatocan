require 'test_helper'

class RsvpqsControllerTest < ActionController::TestCase
setup do
  @rsvpq = rsvpqs(:one)
end


#waiting on Gabe
# test "should create rsvpq" do
#   sign_in users(:one)
#   assert_difference('rsvpq.count', 1) do
#     post :create, params: {rsvpq: {event_id: @rsvpq.event_id}}
#   end
# end 

#new test needed to assert correct path

#assert_redirected_to events_path

#assert_redirected_to "http://test.host/login"


#passes
test "should show rsvpq" do
  sign_in users(:one)
  get :show, params:{ id: @rsvpq} 
  assert_response :success
end

# test "should display notice for successfully created" do
#   post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests}}
#   assert_equal 'Rsvp was successfully created.', :notice
# end 

#passes
test "should display FLASH message for invalid email" do
  post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, email: "notavalidemail" } }
  assert_equal 'Please enter a valid email address', flash[:notice]
end

end





# require 'test_helper'

# class RsvpqsControllerTest < ActionController::TestCase
#   setup do
#     @rsvpq = rsvpqs(:one)
#   end

#   # test "should get index" do
#   #   sign_in users(:one)
#   #   get :index
#   #   assert_response :success
#   #   assert_not_nil assigns(:rsvpqs)
#   # end

#   # test "should get new" do
#   #   #sign_in users(:one)
#   #   get :new
#   #   assert_response :success
#   # end


#   # test "should create rsvpq" do
#   #   #sign_in users(:one)
#   #   assert_difference('Rsvpq.count', 1) do
#   #     post :create, params: { rsvpq: { event_id: 'superevent' } }
#   #   end
#   # end

#   #new test needed to assert correct path
#   #assert_redirected_to events_path
#   #assert_redirected_to "http://test.host/login"

#   #passes
#   test "should show rsvpq" do
#     sign_in users(:one)
#     get :show, params:{ id: @rsvpq}
#     assert_response :success
#   end

#   # test "should get edit" do
#   #   sign_in users(:one)
#   #   get :edit
#   #   assert_response :success
#   # end

#   # test "should update rsvpq" do
#   #   patch :update, params:{id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, user_id: @rsvpq.user_id } }
#   #   assert_redirected_to "http://test.host/login"
#   # end

#   #passes
#   test "should display FLASH message for invalid email" do
#     post :create, params: {id: @rsvpq.id, rsvpq: { event_id: @rsvpq.event_id, guests: @rsvpq.guests, email: "notavalidemail" } }
#     assert_equal 'Please enter a valid email address', flash[:notice]
#   end

# end