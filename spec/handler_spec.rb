# -*- coding: utf-8 -*-
require "env"

describe M2Config::Handler do
  
  describe "::new" do
    it "needs the ØMQ addresses and a send identifier" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev-example-comID"})
      res = CFG.db[:handler].first
      res[:send_spec].should eq("tcp://10.0.0.1:8989")
      res[:recv_spec].should eq("tcp://10.0.0.1:9898")
      res[:send_ident].should eq("dev-example-comID")
    end
  
    it "turns nil into empty string when recv_ident is not set" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev-example-comID"})
      res = CFG.db[:handler].first
      res[:recv_ident].should be_empty
    end
    
    describe "helps you spot common mistakes:" do
      it "yells when the addresses are the same" do
        expect do
          M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8989", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev.example.com ID"})
        end.to raise_exception(ArgumentError, /send and receive endpoints can not be the same/i) 
      end
  
      it "yells when the send ID does not respect Mongrel2's constraints (UUID = (alpha | digit | '-')+ )" do
        expect do
          M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8988", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev.example.com ID"})
        end.to raise_exception(ArgumentError, /Handler send and recv IDs must only use -a-zA-Z0-9/i) 
        expect do
          M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8988", recv_spec:"tcp://10.0.0.1:8989", recv_ident: "dev.example.com ID"})
        end.to raise_exception(ArgumentError, /Handler send and recv IDs must only use -a-zA-Z0-9/i) 
      end
  
    end
  end  
  
  describe '#type' do
    it 'returns its type' do
      M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8988", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev-example-comID"}).type.should eq("handler")
    end
  end
end
