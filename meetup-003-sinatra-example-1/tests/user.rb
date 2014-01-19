#ENV['RACK_ENV'] = 'test'

require_relative '../app'

require 'test/unit'
require 'rack/test'

class UserTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app  
    MyApp # required for Rack::Test
  end
    
  def test_user_routes

    # remove all users
    get "/users"
    users = JSON.parse(last_response.body)
    users.each do |user|
      delete "/users/#{user['username']}"
      assert last_response.ok?
    end
    get "/users"
    assert last_response.ok?

    username = 'kreeves' + rand(100).to_s
    
    # create a user
    post "/users", { user: { username: username, first_name: 'Keanu', last_name: 'R' }}
    user = JSON.parse(last_response.body)
    assert_equal user['username'], username 

    new_last_name = 'Reeves'

    # update our user
    put "/users", { user: { username: username, last_name: new_last_name }}
    user = JSON.parse(last_response.body)
    assert_equal user['last_name'], new_last_name
    
    # fetch our user
    get "/users/#{username}"
    user = JSON.parse(last_response.body)
    assert_equal user['username'], username
    
    # delete our user
    delete "/users/#{username}"
    assert last_response.ok?
    
    # fetch our user again and make sure he doesn't exist
    get "/users/#{username}"
    assert_equal last_response.status, 410
    
  end
    
end