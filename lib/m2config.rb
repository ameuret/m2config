require "sequel"
require "uuid"

module M2Config

  class Config

    DEFAULT_CONFIG = "config.sqlite"
    SCHEMA = File.read("#{File.dirname __FILE__}/m2config/schema.sql")
  
    attr_reader :db
    
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
    
    def initialize(fileName = DEFAULT_CONFIG, options={})
      @fileName = fileName
      creating = ! (File.exists? @fileName)
      @db = Sequel.connect "sqlite://#{@fileName}"
      
      @db.run SCHEMA if creating
 
      Sequel::Model.db = @db
  
      require "m2config/server"
      require "m2config/host"
      require "m2config/dir"
      require "m2config/route"
      require "m2config/proxy"
      require "m2config/handler"
      require "m2config/setting"
      require "m2config/mimetype"

      M2Config::MimeType.populate_table(nil,options[:ignoreDoubles]) if creating
    end
    
    def add_server( settings = {} )
      srv = Server.new settings
    end
  
    def []=( k, v )
      Setting.new k, v
    end
  
  end
end
