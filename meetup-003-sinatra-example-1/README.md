A Neo4j + Neography + Sinatra Example
==
The goal of this example is to demonstrate Ruby with Neo4j in the simplest way possible, without getting caught up with Java, JRuby, Rails, ActiveRecord, etc.

In the spirit of a modern "API first" application, the code offers a simple set of web services.  Later we can add some web pages to further demonstrate examples but for now we have a simple set of tests. 

Technologies Used
==

* Neo4j: a graph database
* Ruby: a popular, easy to learn programming language
* Sinatra: a Ruby library that provides an easy way to create web services or serve web pages (http://www.sinatrarb.com)

Setup
==

1. Install Ruby:  https://www.ruby-lang.org/en/installation
2. Install Neo4j:  http://www.neo4j.org/download
3. Install required Ruby gems for this example:

````
cd <to this directory>
bundle install
````

Run
==

1. Make sure your Neo4j server is started
````./<Neo4j directory>/bin/neo4j start````
  
2. Start our Ruby web server
````thin -R config.ru start````

3. Open a *new* console window and run our tests
````ruby tests/user.rb````

Extra Credit Reading
--
* Rack: a simple way to run and host Ruby (http://rack.github.io, http://goo.gl/P2lzM)
* Thin: a popular web server (http://code.macournoyer.com/thin)