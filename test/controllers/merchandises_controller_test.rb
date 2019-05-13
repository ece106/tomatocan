require 'test_helper'

class MerchandisesControllerTest < ActionController::TestCase
    setup do
    @merchandise = merchandises(:one)
end

test "should get index" do
    get :index
    assert_response :success
    #assert_not_nil assigns(:merchandises)
end

test "should show merchandise" do
    get :show, params: { id: @merchandise.id }
    assert_response :success
end

test "should get new if user signed in" do
    sign_in users(:one)
    get :new
    assert_response :success
end

# #Fix this, Doesn't really work how its supposed to because code doesn't prevent this
# test "shouldn't get new if no user signed in" do
#   get :new, params: {id: @merchandise.id}
#   assert_response :success
# end

test "should get new with merchandise id" do
    sign_in users(:one)
    get :new , params: { id: @merchandise.id }
    assert_response :success
end

test "should get edit" do
    sign_in users(:one)
    get :edit, params: { id: @merchandise.id }
    assert_response :success
end

# test "insert name" do
#   sign_in users(:one)
#   post :create, params: { merchandise: { name: 'chris'}}
#   assert_equal(@users.name, 'chris')
# end

# Is this really needed?
# test "should create merchandise" do
#     sign_in users(:one)
#     assert_difference('Merchandise.count', 1) #do
#     #     post :create, params: { merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
#     #     assert_redirected_to user_profile_path(users(:one).permalink)
#     # end
# end

test "should redirect successful merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: '20', desc: 'test1', buttontype: 'one' }}
    assert_redirected_to user_profile_path(users(:one).permalink)
end

test "should throw flag after successful merchandise creation" do
    sign_in users(:one)
    post :create, params: { merchandise: { name: 'chris', user_id: '1', price: '20', desc: 'test1', buttontype: 'one' }}
    assert_equal 'Patron Perk was successfully created.', flash[:notice]
end

test "should throw flag for no price" do
  sign_in users(:one)
  post :create, params: { merchandise: { name: 'chris', user_id: '1', desc: 'test1', buttontype: 'one' }}
  assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
end

test "should redirect failed merchandise creation attempt for no price" do
  sign_in users(:one)
  post :create, params: { merchandise: { name: 'chris', user_id: 1, desc: 'test', buttontype: 'Buy' }}
  assert_template :new
end

test "should throw flag for no name" do
  sign_in users(:one)
  post :create, params: { merchandise: { price: '20', user_id: '1', desc: 'test1', buttontype: 'one' }}
  assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
end

test "should redirect failed merchandise creation attempt for no name" do
  sign_in users(:one)
  post :create, params: { merchandise: { price: '20', user_id: 1, desc: 'test', buttontype: 'Buy' }}
  assert_template :new
end

test "should throw flag for no price and no name" do
  sign_in users(:one)
  post :create, params: { merchandise: { user_id: '1', desc: 'test1', buttontype: 'one' }}
  assert_equal flash[:notice], 'Your merchandise was not saved. Check the required info (*), filetypes, or character counts.'                                    
end

test "should redirect failed merchandise creation attempt for no price and no name" do
  sign_in users(:one)
  post :create, params: { merchandise: { user_id: 1, desc: 'test', buttontype: 'Buy' }}
  assert_template :new
end

test "should redirect back to merchandise after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'Buy' }}
    assert_redirected_to merchandise_path(assigns(:merchandise))
end

test "should throw flag after merchandise updated" do
    sign_in users(:one)
    patch :update, params: {id: @merchandise, merchandise: { name: 'chris', user_id: 1, price: 20, desc: 'test', buttontype: 'one' }}
    assert_equal flash[:notice], 'Patron Perk was successfully updated.'
end

test "should redirect failed update attempt" do
  sign_in users(:one)
  patch :update, params: {id: @merchandise, merchandise: { name: '', user_id: '', price: '', desc: '', buttontype: ''}}
  #assert_equal flash[:notice], 'Patron Perk was successfully updated.' 
  assert_template :edit
end

test "should set merchandise" do
    assert @merchandise.valid?
end

test "should set user" do
    @user = User.find(@merchandise.user_id)
    assert @user.valid?
end
 
#Is this needed? Does it even test the right thing?
# test "should confirm user not signed in as different user" do
#   sign_in users(:one)
#   first_user = users(:one)
#   duplicate_user = users(:two)
#   assert_not_same(first_user, duplicate_user)
# end

test "should render correct layout for edit" do
    sign_in users(:one)
    get :edit, params: { id: @merchandise.id }
    assert_template 'userpgtemplate'
end

test "should render correct layout for show" do
    get :show, params: { id: @merchandise.id }
    assert_template 'userpgtemplate'
end

test "should render correct layout for index" do
    get :index
    assert_template 'application'
end

test "should render correct layout for new" do
    get :new
    assert_template 'application'
end

# test "should check whether a reward is expired or not" do
#     sign_in users(:one)
#     assert_not_same(@expiredmerch, notexpiredmerch)
# end

end
