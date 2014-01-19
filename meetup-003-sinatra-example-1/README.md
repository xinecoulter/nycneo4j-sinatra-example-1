Introduction
==
This example demonstrates a simple Ruby based web service API using Neo4j for persistence. For simplicity and speed, we are using Rack with Sinatra.  

Neo4j is a graph database.  (Yes, we include it in this code sample to make things easier for newcomers.)

"Rack is a convenient way to build your Ruby app out of a bunch of thin layers, like a stack of pancakes. The layers are called middleware." (http://rack.github.io, http://goo.gl/P2lzM) 

Sinatra is a lightweight framework which sits on top of Rack to make writing web services easy. (http://www.sinatrarb.com)

We also use Thin, which is a fast Ruby web server. (http://code.macournoyer.com/thin)

Setup
==
1.  Install our required Ruby gems via ````bundle install````

Starting the Server
==
Start Neo4j and then start our web server.

````
./neo4j-community-2.0/bin neo4j start
thin -R config.ru start
````

Try it Out!
==
You can either make your own HTTP calls to the server (ie. with curl) or just run the included tests.  In order to keep things simple, we use Rack::Test. 

Open a new console window while your server is running and run:

````ruby tests/user.rb````

