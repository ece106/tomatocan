require 'test_helper'
require 'json'

class Api::V1::SessionsControllerTest < ActionController::TestCase

  test "missing user_login parameter should return 422" do
    post :create, as: :json, params: nil
    assert_response 422
  end

  test "failed login should return 401" do  
    # invalid email
    post :create, as: :json, params: {user: {email: "invalidmail@gmail.com", password:"user1234"}}
    assert_response 401
    # invalid password
    post :create, as: :json, params: {user: {email: "thinqtesting@gmail.com", password:"wrongpassword"}}
    assert_response 401
    # unconfirmed user
    post :create, as: :json, params: {user: {email: "unconfirmed@gmail.com", password:"user1234"}}
    assert_response 401
  end

  # Must test with a confirmed user
  test "successful login should renew auth token" do
    post :create, as: :json, params: {user: {email: "thinqtesting@gmail.com", password:"user1234"}}
    first_token = JSON.parse(response.body)['token']
    post :create, as: :json, params: {user: {email: "thinqtesting@gmail.com", password:"user1234"}}
    assert_not_equal first_token, JSON.parse(response.body)['token']
  end

  test "successful login should return user info" do
    post :create, as: :json, params: {user: {email: "fake@fake.com", password:"user1234"}}
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['success']
    assert_not_nil json_response['name']
    assert_not_nil json_response['permalink']
    assert_not_nil json_response['about']
    assert_not_nil json_response['token']
  end

  test "signout should return username only" do
    sign_in users(:one)
    delete :destroy, params: {user: {email: "fake@fake.com"}}
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['success']
    assert_not_nil json_response['name']
    assert_nil json_response['permalink']
    assert_nil json_response['id']
  end
end