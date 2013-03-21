require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Server do
  before(:each) do
    File.delete DEFAULT_DB_NAME rescue nil
    @cfg = M2Config::Config.new
    @db = SQLite3::Database.new DEFAULT_DB_NAME
    @db.results_as_hash = true
    @srv = M2Config::Server.new
    @host = M2Config::Host.new({matching:"example.com"})
  end
  
  after(:each) do
    @db.close if @db && !@db.closed?
  end  

  describe '::new' do # , {focus: true}
    it 'creates a server entry with reasonable default settings' do
      res= @db.get_first_row("SELECT * FROM server;")
      res["access_log"].should eq(M2Config::Server::ACCESS_LOG)
      res["error_log"].should eq(M2Config::Server::ERROR_LOG)
      res["pid_file"].should eq(M2Config::Server::PID_FILE)
      res["chroot"].should eq(M2Config::Server::CHROOT)
      res["default_host"].should eq(M2Config::Server::DEFAULT_HOST)
      res["name"].should eq(M2Config::Server::NAME)
      res["bind_addr"].should eq(M2Config::Server::BIND_ADDR)
      res["port"].should eq(M2Config::Server::PORT)
      res["use_ssl"].should eq(M2Config::Server::USE_SSL)
    end
    
  end
  
  describe '#add_host (assigns the given host to the server)' do
    it 'accepts an existing Host instance' do
      @srv.add_host @host
      res= @db.get_first_row("SELECT * FROM host WHERE id=?;", @host.id)
      res["server_id"].should eq(@srv.id)
    end
  end
end
