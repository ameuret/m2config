require "env"

describe M2Config::Server do
  before(:each) do
    @srv = M2Config::Server.new
    @host = M2Config::Host.new({matching:"example.com", name: "ex", server_id:(rand 42)})
  end

  describe '::new' do
    it 'creates a server entry with reasonable default settings' do
      res = CFG.db[:server].first
      expect(res[:access_log]).to eq(M2Config::Server::ACCESS_LOG)
      expect(res[:error_log]).to eq(M2Config::Server::ERROR_LOG)
      expect(res[:pid_file]).to eq(M2Config::Server::PID_FILE)
      expect(res[:control_port]).to eq(M2Config::Server::CONTROL_PORT)
      expect(res[:chroot]).to eq(M2Config::Server::CHROOT)
      expect(res[:default_host]).to eq(M2Config::Server::DEFAULT_HOST)
      expect(res[:name]).to eq(M2Config::Server::NAME)
      expect(res[:bind_addr]).to eq(M2Config::Server::BIND_ADDR)
      expect(res[:port]).to eq(M2Config::Server::PORT)
      expect(res[:use_ssl]).to eq(M2Config::Server::USE_SSL)
    end
    
  end
  
  describe '::first (from Sequel::Model)' do
    it 'returns the first server found in the database' do
      srv = M2Config::Server.first
      expect(srv.id).to eq(@srv.id)
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
      expect(res[:server_id]).to eq(@srv.id)
    end
  end
end
