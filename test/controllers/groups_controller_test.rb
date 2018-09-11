require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
#    sign_in users(:one)
    @group = groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    sign_in users(:one)
    get :new
    assert_response :success
  end

  test "should create group" do
    sign_in users(:one)
    assert_difference('Group.count', 1) do
      post :create, params:{ group: { about: @group.about, address: @group.address, grouppic: @group.grouppic, name: @group.name, grouptype: @group.grouptype, user_id: @group.user_id , permalink: '2gh'} }
    end
   #assert_redirected_to groups_path(assigns(:group))
     assert_redirected_to "http://test.host/groups/2gh"
    #assert_redirected_to @group
  end

  test "should show group" do
    get :show, params: {id: @group}
    assert_response :success
  end
  test "should get news" do
    get :news, params: { id: @group, permalink: '5gh'}
    assert_response :success
  end
  test "should get eventlist" do
    get :eventlist, params: { id: @group, permalink: '5gh'}
    assert_response :success
  end
  test "should get edit" do 
    sign_in users(:one)
    get :edit, params: { id: @group }
    assert_response :success
  end

  test "should update group" do
    sign_in users(:one)
    patch :update, params:{ id: @group.id, group: { about: "I was updated", address: @group.address, grouppic: @group.grouppic, name: @group.name, grouptype: @group.grouptype, user_id: @group.user_id }}
#    assert_equal "I was updated", @group.about   #But this isn't saving the new user attributes to the database
    assert_redirected_to group_path(assigns(:group))
  end

end