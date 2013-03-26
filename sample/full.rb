require "m2config"

include M2Config

cfg       = M2Config::Config.new
server    = M2Config::Server.new
exComHost = M2Config::Host.new({matching:"example.com", name:"ex"})
pubDir    = M2Config::Dir.new({base:"public/"})
pubRoute  = M2Config::Route.new( {path:"/", target:pubDir} )
appHand   = M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                                    recv_spec:"tcp://10.0.0.1:9898",
                                    send_ident: "dev.example.com ID" })
appRoute  = M2Config::Route.new( {path:"/blog", target:appHand} )

exComHost.add_route appRoute
exComHost.add_route pubRoute
  
cfg["extra"] = 64
  
server.add_host exComHost
