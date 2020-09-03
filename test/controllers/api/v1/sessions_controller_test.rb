require 'test_helper'
require 'json'

class Api::V1::SessionsControllerTest < ActionController::TestCase

  test "failed login should return 401" do
    post :create, as: :json, params: {user: {email: "fake@fake.com", password:"wrongpassword"}}
    assert_response 401
  end

  test "successful login should renew auth token" do
    post :create, as: :json, params: {user: {email: "fake@fake.com", password:"user1234"}}
    first_token = JSON.parse(response.body)['token']
    post :create, as: :json, params: {user: {email: "fake@fake.com", password:"user1234"}}
    assert_not_equal first_token, JSON.parse(response.body)['token']
  end

  test "successful login should return user info" do
    post :create, as: :json, params: {user: {email: "fake@fake.com", password:"user1234"}}
    json_response = JSON.parse(response.body)
    assert_not_nil(json_response['success'])
    assert_not_nil(json_response['name'])
    assert_not_nil(json_response['token'])
    assert_not_nil(json_response['permalink'])
  end

end