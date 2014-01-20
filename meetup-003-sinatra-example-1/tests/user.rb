#ENV['RACK_ENV'] = 'test'

require_relative '../app'

require 'test/unit'
require 'rack/test'

class UserTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app  
    MyApp # required for Rack::Test
  end
    
  def test_users
      
    username1 = 'kreeves' + rand(100).to_s      # Neo from the Matrix
    
    # create a user
    post "/users", { user: { username: username1, first_name: 'Keanu', last_name: 'R' }}
    user = JSON.parse(last_response.body)
    assert_equal user['username'], username1 
    
    new_last_name = 'Reeves'
    
    # update our user
    put "/users", { user: { username: username1, last_name: new_last_name }}
    user = JSON.parse(last_response.body)
    assert_equal user['last_name'], new_last_name
    
    # fetch our user
    get "/users/#{username1}"
    user = JSON.parse(last_response.body)
    assert_equal user['username'], username1
    
    # delete our user
    delete "/users/#{username1}"
    assert last_response.ok?
    
    # fetch our user again and make sure he doesn't exist
    get "/users/#{username1}"
    assert_equal last_response.status, 410
      
  end
  
  def test_user_to_user_relationships
               
    username1 = 'kreeves' + rand(100).to_s      # Neo from the Matrix
    username2 = 'lfishburne' + rand(100).to_s   # Morpheus
        
    # create another user
    post "/users", { user: { username: username1, first_name: 'Keanu', last_name: 'Reeves' }}    
    post "/users", { user: { username: username2, first_name: 'Laurence', last_name: 'Fishburne' }}
    
    # have Neo follow Morpheus
    post "/users/#{username1}/follow/#{username2}"
    assert last_response.ok?
    
    # list the people Neo follows and make sure it's Morpheus
    get "/users/#{username1}/following"
    users = JSON.parse(last_response.body)
    assert users.class == Array
    assert_equal users[0]['username'], username2  

    cleanup
  end
  
  private
  
    def cleanup
      # clean up and remove all users
      get "/users"
      users = JSON.parse(last_response.body)
      users.each do |user|
        delete "/users/#{user['username']}"
      end
    end
    
end