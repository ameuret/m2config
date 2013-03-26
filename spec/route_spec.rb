require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Route do
  before(:each) do
    File.delete DEFAULT_DB_NAME rescue nil
    @cfg = M2Config::Config.new
    @dirH = M2Config::Dir.new({base: "static/"})
    @db = SQLite3::Database.new DEFAULT_DB_NAME
    @db.results_as_hash = true
  end
  
  after(:each) do
    @db.close if @db && !@db.closed?
  end  
  
  describe "::new" do
    it "needs to know the path pattern and the target handler" do
      M2Config::Route.new({path:"/blog", target: @dirH})
      res = @db.get_first_row("SELECT * FROM route;")
      res["path"].should eq("/blog")
      res["target_id"].should eq(@dirH.id)
      res["target_type"].should eq(@dirH.type)
    end
  end
  
  describe "#host=" do
    it "can be used if the host is not known at creation" do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      r = M2Config::Route.new({path:"/blog", target: @dirH})
      r.host = host.id
      res = @db.get_first_row("SELECT * FROM route;")
      res["host_id"].should eq(host.id)
    end
    
    it "can take a Host instance" do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      r = M2Config::Route.new({path:"/blog", target: @dirH})
      r.host = host
      res = @db.get_first_row("SELECT * FROM route;")
      res["host_id"].should eq(host.id)
    end
  end
  
  describe '#host' do # , {focus: true}
    it 'returns the associated Host object'  do
      r = M2Config::Route.new({path:"/blog", target: @dirH})
      r.host = M2Config::Host.new({matching:"example.com", name: "ex"})
      r.host.matching.should eq("example.com")
    end
  end

  describe '#target=' do
    it 'reassigns the target object' do
      r = M2Config::Route.new({path:"/blog", target: @dirH})
      newTarget = M2Config::Proxy.new({addr:"127.0.0.1", port: 15970})
      r.target = newTarget
      res = @db.get_first_row("SELECT * FROM route;")
      res["target_id"].should eq(newTarget.id)
      res["target_type"].should eq(newTarget.type)
    end
  end
  
  describe '#target' do
    it 'returns the Target object' do
      r = M2Config::Route.new({path:"/blog", target: @dirH})
      r.target.base.should eq @dirH.base
    end
  end

end
