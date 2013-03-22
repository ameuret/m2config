CAVEAT EMPTOR
-------------

THIS LIB IS VERY YOUNG. ALTHOUGH IT SEEMS TO WORK SO FAR I AM JUST
STARTING TO USE IT IN THE FIELD SO EVEN THOUGH THE SPECS PASS IT MAY
BREAK STUFF.


M2config
========
[![Build Status](https://travis-ci.org/ameuret/m2config.png?branch=master)](https://travis-ci.org/ameuret/m2config)
[![Code Climate](https://codeclimate.com/github/ameuret/m2config.png)](https://codeclimate.com/github/ameuret/m2config)  
  
Manage your Mongrel2 configuration database using handy model classes
that map Servers, Hosts, Routes, Directories, Proxies, Handlers and Settings.

Installation
------------

Add this line to your application's Gemfile:

    gem 'm2config'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install m2config

Usage
-----

Thanks to the sane default values set by M2Config, creating a basic
Mongrel2 configuration can be as simple as running:

```ruby
require "m2config"

cfg       = M2Config::Config.new
server    = M2Config::Server.new
exComHost = M2Config::Host.new({matching:"example.com"})
pubDir    = M2Config::Dir.new({base:"/public"})
pubRoute  = M2Config::Route.new({path:"/", target:pubDir})

exComHost.add_route pubRoute
server.add_host exComHost
```

Keep in mind that these lines will create their corresponding database
records every time the script is run. For simplicity there is no check
for duplicates. This has the benefit of complete flexibility and
control but *you* must ensure that the DB ends up looking the way you
want.

You can swiftly dump your config using:

```ruby
require "pp"

pp Server.all
pp Host.all
pp Handler.all
pp Dir.all
pp Route.all

```

### This is Sequel

The classes mapping the configuration are
[Sequel](http://sequel.rubyforge.org/) models. I just added some
syntactic sugar but you can use them as plain Sequel::Model objects.

TODO
----
  
A few features that you may miss if your needs go beyond mine:

  - MIME types are not handled (trivial to add, just ask)
  - Multiple DBs in same process
  - A DSL-like syntax (likely to improve readability in complex setups)
  - Declare proper associations
  - Cleanup / consolidate DB (delete unreferenced entries)
  
  
  
Contributing
------------
  
Start simply with an issue (even for a feature request).
  
Otherwise if you feel like helping directly:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
