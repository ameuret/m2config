require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Proxy do
  
  describe "::new" do
    it "needs an address and a port number" do
      M2Config::Proxy.new({addr:"legacy.local", port: 8080})
      res = CFG.db[:proxy].first
      res[:addr].should eq("legacy.local")
      res[:port].should eq(8080)
    end
  end
  
  describe '#type' do
    it 'returns its type' do
      M2Config::Proxy.new({addr:"legacy.local", port: 8080}).type.should eq("proxy")
    end
  end
  
end
