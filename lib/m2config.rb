require "sequel"
require "uuid"

module M2Config

  class Config

    DEFAULT_CONFIG = "config.sqlite"
    SCHEMA = File.read("#{File.dirname __FILE__}/m2config/schema.sql")
    
    @@foundTables = []
    
    def self.tables
      return @@foundTables unless @@foundTables.empty?
      SCHEMA.split("\n").each do 
        |l|
        if l =~ /CREATE TABLE (\w+)/
          @@foundTables.push $1
        end
      end
      @@foundTables
    end
    
    def initialize( fileName = DEFAULT_CONFIG )
      @fileName = fileName
      creating = ! (File.exists? @fileName)
      @db = Sequel.connect "sqlite://#{@fileName}"
      
      @db.run SCHEMA if creating

      require "m2config/server"
      M2Config::Server.db = @db
      require "m2config/host"
      M2Config::Host.db = @db
      require "m2config/dir"
      M2Config::Dir.db = @db
      require "m2config/route"
      M2Config::Route.db = @db
      require "m2config/proxy"
      M2Config::Proxy.db = @db
      require "m2config/handler"
      M2Config::Handler.db = @db
      require "m2config/setting"
      M2Config::Setting.db = @db
    end
    
    def add_server( settings = {} )
      srv = Server.new settings
    end
  
    def []=( k, v )
      Setting.new k, v
    end
  
  end
end
