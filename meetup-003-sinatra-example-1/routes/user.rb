# encoding: utf-8
class MyApp < Sinatra::Application
  
  USER_INDEX = "user_index"
  USER_INDEX_KEY = "username"
  FOLLOWS_REL = "FOLLOWS"
  
  # curl http://localhost:3000/users
  get "/users" do
    begin
      # list all users
      nodes = $neo.execute_query("MATCH (n:User) RETURN n")
    
      items = []
      nodes["data"].each do |hash| 
        n = Neography::Node.load hash[0]
        items << serialize(n)
      end
      items.to_json
    rescue Exception => err
      status 500
      body err
    end
  end
  
  # show user
  # curl http://localhost:3000/users/smith3
  get "/users/:username" do
    begin
      node = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
      if node.nil?
        status 410 
        body 'Not found' and return
      end
    
      # TODO move to_json to node as a wrapped model
      # TODO render it as officially json
      serialize(node).to_json
    rescue Exception => err
      status 500
      body err
    end
  end
  
  # create user
  # curl -XPOST -d "user[username]=smith4&user[first_name]=joe" http://localhost:3000/users
  post "/users" do
    begin      
      node = Neography::Node.create_unique USER_INDEX, USER_INDEX_KEY, params['user']['username'], params['user'], $neo
      $neo.add_label(node, "User")
      serialize(node).to_json
    rescue Exception => err
      status 500
      body err
    end
  end

  # update user
  # curl -XPUT -d "user[username]=smith4&user[first_name]=joe123" http://localhost:3000/users
  put "/users" do
    node = Neography::Node.find(USER_INDEX, USER_INDEX_KEY, params['user']['username'])
    $neo.set_node_properties node.neo_id, params['user']
    node = Neography::Node.find(USER_INDEX, USER_INDEX_KEY, params['user']['username'])
    serialize(node).to_json
  end  
  
  # delete user
  # curl -XDELETE http://localhost:3000/users/smith3
  delete "/users/:username" do
    begin
      node = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
      if node.nil?
        status 410 
        body 'Not found' and return
      end
      $neo.delete_node! node # TODO* complain that the ! is needed if the node has relationships
                             # TODO* complain that finding the real server error doesn't seem to be documented
    rescue Exception => err
      status 500
      body err.backtrace # TODO puts in development, log in production
    end
  end
  
  # follow another user
  post "/users/:username/follow/:other_username" do
    begin
      node1 = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
      node2 = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['other_username']
      if node1.nil? or node2.nil?
        status 410
        body 'Not found' and return
      end
      node1.outgoing(FOLLOWS_REL) << node2
      {}.to_json
    rescue Exception => err
      status 500
      body err
    end
  end
  
  # list users someone follows
  get "/users/:username/following" do
    begin
      node = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
      nodes = node.outgoing(FOLLOWS_REL)
      nodes.map { |n| serialize(n) }.to_json
    rescue Exception => err
      status 500
      body err.backtrace # TODO puts in development, log in production
    end
  end 
  
  # # check into a drink
  # post "/users/:username/post" do
  #   begin
  #     # get user
  #     user_node = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
  #     
  #     # find drink by ID
  #     drink_node = Neography::Node.find USER_INDEX, USER_INDEX_KEY, params['username']
  #     
  #     # create checkin node
  #     checkin_node = Neography::Node.create_unique DRINK_INDEX, DRINK_INDEX_KEY, params['drink']['name'], params['drink'], $neo
  #     $neo.add_label(node, "Checkin")
  #     
  #     
  #   rescue Exception => err
  #     status 500
  #     body err.backtrace
  #   end
  # end
    
  private
  
    def serialize(user)
      # TODO find out why we can't use colon instead of rocket
      { 
        "id" => user.neo_id, # TODO never show real ID in production
        "username" => user.username,
        "first_name" => user.first_name,
        "last_name" => user.last_name
      }
    end
end