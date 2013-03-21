require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Host do
  before(:each) do
    File.delete DEFAULT_DB_NAME rescue nil
    @cfg = M2Config::Config.new
    @db = SQLite3::Database.new DEFAULT_DB_NAME
    @db.results_as_hash = true
    @srv = @cfg.add_server
  end
  
  after(:each) do
    @db.close if @db && !@db.closed?
  end  
  
  describe "::new" do
    it "needs to know the domain name served" do
      M2Config::Host.new({matching:"example.com"})
      res = @db.get_first_row("SELECT * FROM host;")
      res["matching"].should eq("example.com")
    end
    
    it "can use the uuid of a server" do
      host = M2Config::Host.new({matching:"example.com", srvUuid: @srv.uuid})
      res = @db.get_first_row("SELECT * FROM host WHERE id=?;", host.id)
      res["server_id"].should eq(@srv.id)
      res["matching"].should eq("example.com")
    end
  
    it "can use a server instance" do
      host = M2Config::Host.new({matching:"example.com", srv: @srv})
      res = @db.get_first_row("SELECT * FROM host WHERE id=?;", host.id)
      res["server_id"].should eq(@srv.id)
      res["matching"].should eq("example.com")
    end
  end
  
  describe "#add_route" do
    it "activates a route (can be done using Route#host= too)" do
      host = M2Config::Host.new({matching:"example.com"})
      dirH = M2Config::Dir.new({base: "/static"})
      dirR = M2Config::Route.new({path:"/blog", target: dirH})
      host.add_route dirR
      res = @db.get_first_row("SELECT * FROM route;")
      res["host_id"].should eq(host.id)
    end
  end    
end
