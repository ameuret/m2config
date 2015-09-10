require "env"

describe M2Config::Server do
  before(:each) do
    @srv = M2Config::Server.new
    @host = M2Config::Host.new({matching:"example.com", name: "ex", server_id:(rand 42)})
  end

  describe '::new' do
    it 'creates a server entry with reasonable default settings' do
      res = CFG.db[:server].first
      res[:access_log].should eq(M2Config::Server::ACCESS_LOG)
      res[:error_log].should eq(M2Config::Server::ERROR_LOG)
      res[:pid_file].should eq(M2Config::Server::PID_FILE)
      res[:control_port].should eq(M2Config::Server::CONTROL_PORT)
      res[:chroot].should eq(M2Config::Server::CHROOT)
      res[:default_host].should eq(M2Config::Server::DEFAULT_HOST)
      res[:name].should eq(M2Config::Server::NAME)
      res[:bind_addr].should eq(M2Config::Server::BIND_ADDR)
      res[:port].should eq(M2Config::Server::PORT)
      res[:use_ssl].should eq(M2Config::Server::USE_SSL)
    end
    
  end
  
  describe '::first (from Sequel::Model)' do
    it 'returns the first server found in the database' do
      srv = M2Config::Server.first
      srv.id.should eq(@srv.id)
    end
  
    it 'raises if there is more than one server' do
      M2Config::Server.new
      expect { M2Config::Server.first }.to raise_exception /Careful ! You are calling Server.first on a database holding multiple servers/
    end
  end
  
  describe '#add_host (assigns the given host to the server)' do
    it 'accepts an existing Host instance' do
      @srv.add_host @host
      res = CFG.db[:host].where(id: @host.id).first
      res[:server_id].should eq(@srv.id)
    end
  end
end
