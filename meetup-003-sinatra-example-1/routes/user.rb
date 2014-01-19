# encoding: utf-8
class MyApp < Sinatra::Application
  
  # curl http://localhost:3000/users
  get "/users" do
    
    # list all users
    nodes = $neo.execute_query("MATCH (n:User) RETURN n")
    
    items = []
    nodes["data"].each do |hash| 
      n = Neography::Node.load hash[0]
      items << serialize(n)
    end
    items.to_json
  end
  
  # show user
  # curl http://localhost:3000/users/smith3
  get "/users/:username" do
    
    node = Neography::Node.find "user", "username", params['username']
    if node.nil?
      status 410 
      body 'Not found' and return
    end
    
    # TODO move to_json to node as a wrapped model
    # TODO render it as officially json
    serialize(node).to_json
  end
  
  # create user
  # curl -XPOST -d "user[username]=smith4&user[first_name]=joe" http://localhost:3000/users
  post "/users" do
    # TODO update if already exists
    # TODO wrap in model method, validate params
    # TODO handle json, with curl example
    node = Neography::Node.create_unique "user", "username", params['user']['username'], params['user'], $neo
    # TODO what if an error occurs? how to show error message?
    $neo.add_label(node, "User")
    serialize(node).to_json
  end

  # update user
  # curl -XPUT -d "user[username]=smith4&user[first_name]=joe123" http://localhost:3000/users
  put "/users" do
    node = Neography::Node.find("user", "username", params['user']['username'])
    $neo.set_node_properties node.neo_id, params['user']
    node = Neography::Node.find("user", "username", params['user']['username'])
    serialize(node).to_json
  end  
  
  # delete user
  # curl -XDELETE http://localhost:3000/users/smith3
  delete "/users/:username" do
    node = Neography::Node.find "user", "username", params['username']
    if node.nil?
      status 410 
      body 'Not found' and return
    end
    $neo.delete_node node
  end
  
  private
  
    def serialize(user)
      # TODO find out why we can't use colon instead of rocket
      { 
        "id" => user.neo_id,
        "username" => user.username,
        "first_name" => user.first_name,
        "last_name" => user.last_name
      }
    end
end