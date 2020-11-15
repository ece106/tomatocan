require 'test_helper'
require 'json'

class Api::UsersApiTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  test 'POST /api/v1/register' do
    post '/api/v1/register', user: {email: "new-user@example.com", name: "new-user",
      permalink: "newuser", password: "password"}
    assert_equal(201, last_response.status, 'Successful registration has status code 201')
    assert(JSON.parse(last_response.body).has_key?('token'), 'Successful registration returns token')

    post '/api/v1/register'
    assert_equal(409, last_response.status, 'Failed registration has status code 409')
    assert(JSON.parse(last_response.body).has_key?('errors'), 'Failed registration returns list of errors')
  end

  test 'POST /api/v1/login' do
    post 'api/v1/login', email: 'fake@fake.com', password: 'user1234'
    assert_equal(200, last_response.status, 'Successful login has status code 200')
    assert(JSON.parse(last_response.body).has_key?('token'), 'Successful login returns token')

    post 'api/v1/login'
    assert_equal(401, last_response.status, 'Failed login has status code 401')
  end

  test 'GET /api/v1/users/:permalink should return info about specified user' do
    get '/api/v1/users/non-existent-user'
    assert_equal(404, last_response.status, 'Status is 404 when user does not exist')
    
    get '/api/v1/users/user1'
    assert_equal(200, last_response.status, 'Status is 200 when user exists')
    assert_equal('Phineas', JSON.parse(last_response.body)['name'], 'Returned user info should match the given permalink')
  end

  test 'PUT /api/v1/users/:permalink should update user, if authorized' do
    put '/api/v1/users/user1'
    assert_equal(401, last_response.status, 'Status is 401 for unauthorized request')

    post '/api/v1/login', email: 'fake@fake.com', password: 'user1234'
    token = JSON.parse(last_response.body)['token']

    header 'Authorization', "Bearer #{token}"
    put 'api/v1/users/user', current_password: 'user1234'
    assert_equal(401, last_response.status, 'Authorized user must match the given permalink')

    put 'api/v1/users/user1', current_password: 'user1234'
    assert_equal(200, last_response.status, 'Status is 200 for successful update')

    put 'api/v1/users/user1', current_password: 'user1234', permalink: 'user2'
    assert_equal(409, last_response.status, 'Status is 409 for unsuccessful update')
    assert(JSON.parse(last_response.body).has_key?('errors'), 'Unsuccessful update returns list of errors')
  end

  test 'GET /api/v1/events' do
    get '/api/v1/events'
    assert_equal(200, last_response.status, 'Status is 200')
    assert(JSON.parse(last_response.body).kind_of?(Array), 'Returns an array')
  end

  test 'POST /api/v1/events' do
    post '/api/v1/events'
    assert_equal(401, last_response.status, 'Status is 401 when user is unauthenticated')

    post '/api/v1/login', email: 'fake@fake.com', password: 'user1234'
    token = JSON.parse(last_response.body)['token']
    header 'Authorization', "Bearer #{token}"

    post '/api/v1/events'
    assert_equal(409, last_response.status, 'Status is 409 for unsuccessful post')
    assert(JSON.parse(last_response.body).has_key?('errors'), 'Unsuccessful post returns list of errors')

    post '/api/v1/events', name: 'name', start_at: Time.now + 2.hours, end_at: Time.now + 3.hours
    assert_equal(201, last_response.status, 'Status is 201 for successful post')
  end

  test 'PUT /api/v1/events/:target_event_id' do
    put '/api/v1/events/1'
    assert_equal(401, last_response.status, 'Status is 401 when user is unauthenticated')

    post '/api/v1/login', email: 'fake@fake.com', password: 'user1234'
    token = JSON.parse(last_response.body)['token']
    header 'Authorization', "Bearer #{token}"

    put '/api/v1/events/-1'
    assert_equal(404, last_response.status, 'Status is 404 when event does not exist')

    put '/api/v1/events/2'
    assert_equal(401, last_response.status, 'Status is 401 when event does not belong to authenticated user')

    put '/api/v1/events/1', start_at: 'not_a_datetime'
    assert_equal(409, last_response.status, 'Status is 409 when update is unsuccessful')
    assert(JSON.parse(last_response.body).has_key?('errors'), 'Unsuccessful update returns list of errors')

    put '/api/v1/events/1'
    assert_equal(200, last_response.status, 'Status is 200 on successful update')
  end

  test 'DELETE /api/v1/events/:target_event_id' do
    delete '/api/v1/events/1'
    assert_equal(401, last_response.status, 'Status is 401 when user is unauthenticated')

    post '/api/v1/login', email: 'fake@fake.com', password: 'user1234'
    token = JSON.parse(last_response.body)['token']
    header 'Authorization', "Bearer #{token}"

    delete '/api/v1/events/-1'
    assert_equal(404, last_response.status, 'Status is 404 when event does not exist')

    delete '/api/v1/events/2'
    assert_equal(401, last_response.status, 'Status is 401 when event does not belong to authenticated user')

    delete '/api/v1/events/1'
    assert_equal(200, last_response.status, 'Status is 200 on successful delete')
  end
end