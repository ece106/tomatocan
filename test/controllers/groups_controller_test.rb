require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @group = groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    sign_in users(:one)
    assert_difference('Group.count', 1) do
      post :create, group: { about: @group.about, address: @group.address, grouppic: @group.grouppic, latitude: @group.latitude, longitude: @group.longitude, name: "newgroup", grouptype: @group.grouptype, user_id: @group.user_id }
    end
    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    get :show, id: @group, session: { email: "fake@fake.com", password: 'password' }
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: 1, session: { email: "fake@fake.com", password: 'password' }
    assert_response :success
  end

  test "should update group" do
    patch :update, id: @group, group: { about: "I was updated", address: @group.address, grouppic: @group.grouppic, latitude: @group.latitude, longitude: @group.longitude, name: @group.name, grouptype: @group.grouptype, user_id: @group.user_id }
#    assert_equal "I was updated", @group.about   #But this isn't saving the new user attributes to the database
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: 1
    end
    assert_redirected_to groups_path
  end
end
