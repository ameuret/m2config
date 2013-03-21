require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Proxy do
  before(:each) do
    File.delete DEFAULT_DB_NAME rescue nil
    @cfg = M2Config::Config.new
    @db = SQLite3::Database.new DEFAULT_DB_NAME
    @db.results_as_hash = true
  end
  
  after(:each) do
    @db.close if @db && !@db.closed?
  end  
  
  describe "::new" do
    it "needs an address and a port number" do
      M2Config::Proxy.new({addr:"legacy.local", port: 8080})
      res= @db.get_first_row("SELECT * FROM proxy;")
      res["addr"].should eq("legacy.local")
      res["port"].should eq(8080)
    end
  end
  
  describe '#type' do
    it 'returns its type' do
      M2Config::Proxy.new({addr:"legacy.local", port: 8080}).type.should eq("proxy")
    end
  end
  
end
