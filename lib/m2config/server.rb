module M2Config
  class Server < Sequel::Model(:server)
    ACCESS_LOG = '/logs/access.log'
    ERROR_LOG = '/logs/error.log'
    PID_FILE = '/run/mongrel2.pid'
    CHROOT = './'
    DEFAULT_HOST = 'localhost'
    NAME = 'main'
    BIND_ADDR = '0.0.0.0'
    PORT = 6767
    USE_SSL = 0

    one_to_many :hosts
    
    def initialize( fields={} )
      fields[:uuid]         ||= UUID.new.generate
      fields[:access_log]   ||= M2Config::Server::ACCESS_LOG
      fields[:error_log]    ||= ERROR_LOG
      fields[:pid_file]     ||= PID_FILE
      fields[:chroot]       ||= CHROOT
      fields[:default_host] ||= DEFAULT_HOST
      fields[:name]         ||= NAME
      fields[:bind_addr]    ||= BIND_ADDR
      fields[:port]         ||= PORT
      fields[:use_ssl]      ||= USE_SSL
      super fields, false
      save
    end
  
    def self.first
      raise "Careful ! You are calling Server.first on a database holding multiple servers" if
        ((Server.get {count(id)}) > 1)
      super
    end
    
  end
end
