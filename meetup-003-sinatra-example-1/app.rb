# encoding: utf-8
require 'sinatra'
require 'neography'
require 'net/http'
require 'uri'
require 'json'
require 'sinatra/reloader'
    
class MyApp < Sinatra::Application
  enable :sessions
  set :session_secret, '8V8VNC8V20DHS89HVS8H1NDZV0C7VBFX'
  
  configure :production do
  end

  configure :development do
    # debugging support
    require 'byebug'

    # auto-reload support
    # http://goo.gl/bL6TC7
    Sinatra::Application.reset!
    use Rack::Reloader
  end
  
  helpers do
    include Rack::Utils
  end
    
  # create an app wide connection to Neo4j
  $neo = Neography::Rest.new URI("http://localhost:7474").to_s
end

require_relative 'models/init'
require_relative 'routes/init'