# -*- coding: utf-8 -*-
require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Handler do
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
    it "needs the ØMQ addresses and a send identifier" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev.example.com ID"})
      res = @db.get_first_row("SELECT * FROM handler;")
      res["send_spec"].should eq("tcp://10.0.0.1:8989")
      res["recv_spec"].should eq("tcp://10.0.0.1:9898")
      res["send_ident"].should eq("dev.example.com ID")
    end
  
    it "turns nil into empty string when recv_ident is not set" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev.example.com ID"})
      res = @db.get_first_row("SELECT * FROM handler;")
      res["recv_ident"].should be_empty
    end
    
    describe "helps you spot common mistakes" do
      it "yells when the addresses are the same" do
        expect do
          M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8989", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev.example.com ID"})
        end.to raise_exception(ArgumentError, /send and receive endpoints can not be the same/i) 
      end
  
    end
  end  
  
  describe '#type' do
    it 'returns its type' do
      M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8988", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev.example.com ID"}).type.should eq("handler")
    end
  end
end
