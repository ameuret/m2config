# -*- coding: utf-8 -*-
require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Setting do
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
    it "stores the given value under the given key" do
      M2Config::Setting.new("answer",42)
      res = @db.get_first_row("SELECT * FROM setting;")
      res["value"].should eq("42")
    end
  
    it "updates the existing value if the given key is already present" do
      M2Config::Setting.new("answer",41)
      M2Config::Setting.new("answer",42)
      res = @db.get_first_row("SELECT * FROM setting;")
      res["value"].should eq("42")
    end
  end    
end
