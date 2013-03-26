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
      M2Config::Host.new({matching:"example.com", name: "ex"})
      res = @db.get_first_row("SELECT * FROM host;")
      res["matching"].should eq("example.com")
    end
    
    it "can use the uuid of a server" do
      host = M2Config::Host.new({matching:"example.com", name: "ex", srvUuid: @srv.uuid})
      res = @db.get_first_row("SELECT * FROM host WHERE id=?;", host.id)
      res["server_id"].should eq(@srv.id)
      res["matching"].should eq("example.com")
    end
  
    it "can use a server instance" do
      host = M2Config::Host.new({matching:"example.com", name: "ex", srv: @srv})
      res = @db.get_first_row("SELECT * FROM host WHERE id=?;", host.id)
      res["server_id"].should eq(@srv.id)
      res["matching"].should eq("example.com")
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
      res = @db.get_first_row("SELECT * FROM route;")
      res["host_id"].should eq(host.id)
    end
  end
  
  describe '#check_routes' do
    it 'returns false if some routes have identical paths'  do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      dir1 = M2Config::Dir.new({base: "static/"})
      dir2 = M2Config::Dir.new({base: "images/"})
      host.add_route M2Config::Route.new({path:"/blog", target: dir1})
      host.add_route M2Config::Route.new({path:"/blog", target: dir2})
      host.check_routes.should be_false
    end
  end

end
