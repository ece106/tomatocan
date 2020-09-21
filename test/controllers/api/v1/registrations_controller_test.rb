require 'test_helper'
require 'json'

class Api::V1::RegistrationsControllerTest < ActionController::TestCase 

  test "successful registration should return 201" do
    post :create, as: :json, params: {user: {email: "test10@example.com", name: "test10", permalink: "test10", password: "password"}}
    assert_response 201
  end

  test "successful registration should return user info" do
    post :create, as: :json, params: {user: {email: "test10@example.com", name: "test10", permalink: "test10", password: "password"}}
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['success']
    assert_not_nil json_response['name']
    assert_not_nil json_response['token'] #NOT GENERATING TOKEN
    assert_not_nil json_response['permalink']
  end

  test "failed registration should return 422" do
    post :create, as: :json, params: {user: {email: "test10@example.com", name: "test10", permalink: "test10"}}
    assert_response 422
  end

  test "failed registration should give errors in response" do
    post :create, as: :json, params: {user: {email: "test10@example.com", name: "test10", permalink: "test10"}}
    json_response = JSON.parse(response.body)
    assert_not_nil json_response['errors']
  end

end