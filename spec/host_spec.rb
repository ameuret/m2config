require "env"

describe M2Config::Host do
  before(:each) do
    @srv = CFG.add_server
  end

  describe "::new" do
    it "needs to know the domain name served" do
      M2Config::Host.new({matching:"example.com", name: "ex"})
      res = CFG.db[:host].first
      res[:matching].should eq("example.com")
    end
    
    it "can use the uuid of a server" do
      host = M2Config::Host.new({matching:"example.com", name: "ex", srvUuid: @srv.uuid})
      res = CFG.db[:host].where(id: host.id).first
      res[:server_id].should eq(@srv.id)
      res[:matching].should eq("example.com")
    end
  
    it "can use a server instance" do
      host = M2Config::Host.new({matching:"example.com", name: "ex", srv: @srv})
      res = CFG.db[:host].where(id: host.id).first
      res[:server_id].should eq(@srv.id)
      res[:matching].should eq("example.com")
    end
  
    it "enforces mongrel2 constraint about nil name" do
      expect {
        M2Config::Host.new({matching:"example.com"})
      }.to raise_exception(ArgumentError, /name can not be nil/i) 
    end
  end
  
  describe "#add_route" do
    it "activates a route (can be done using Route#host= too)" do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      dirH = M2Config::Dir.new({base: "static/"})
      dirR = M2Config::Route.new({path:"/blog", target: dirH})
      host.add_route dirR
      res = CFG.db[:route].first
      res[:host_id].should eq(host.id)
    end
  end
  
  describe '#check_routes' do
    it 'returns false if some routes have identical paths'  do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      dir1 = M2Config::Dir.new({base: "static/"})
      dir2 = M2Config::Dir.new({base: "images/"})
      host.add_route M2Config::Route.new({path:"/blog1", target: dir1})
      host.add_route M2Config::Route.new({path:"/blog1", target: dir2})
      host.check_routes.should be_falsey
    end

    it 'returns true if all routes have different paths'  do
      host = M2Config::Host.new({matching:"example2.com", name: "ex"})
      dir1 = M2Config::Dir.new({base: "static/"})
      dir2 = M2Config::Dir.new({base: "images/"})
      r1 = M2Config::Route.new({path:"/blog3", target: dir1})
      r2 = M2Config::Route.new({path:"/images", target: dir2})
      host.add_route r1
      host.add_route r2
      host.check_routes.should be_truthy
    end

    it 'withstands the idea of not having any routes'  do # , {focus: true}
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      host.check_routes.should be_truthy
    end
  end

end
