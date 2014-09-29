require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  setup do
    @group = groups(:one)
  end

  test "should get index" do
    @group = groups(:one)
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create group" do
    post :create, session: { email: "fake@fake.com", password: 'password' }
    assert_difference('Group.count') do
      post :create, group: { about: @group.about, address: @group.address, grouppic: @group.grouppic, latitude: @group.latitude, longitude: @group.longitude, name: @group.name, grouptype: @group.grouptype, user_id: @group.user_id }
    end
    assert_redirected_to group_path(assigns(:group))
  end

  test "should show group" do
    @group = groups(:one)
    get :show, id: @group, session: { email: "fake@fake.com", password: 'password' }
    assert_response :success
  end

  test "should get edit" do
    @group = groups(:one)
      get :edit, id: @group, session: { email: "fake@fake.com", password: 'password' }
    assert_response :success
  end

  test "should update group" do
    @group = groups(:one)
    patch :update, id: @group, group: { about: @group.about, address: @group.address, grouppic: @group.grouppic, latitude: @group.latitude, longitude: @group.longitude, name: @group.name, grouptype: @group.grouptype, user_id: @group.user_id }
    assert_redirected_to group_path(assigns(:group))
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete :destroy, id: @group
    end
    assert_redirected_to groups_path
  end
end
