# -*- coding: utf-8 -*-
require "env"

describe M2Config::Handler do
  
  describe "::new" do
    it "needs the ØMQ addresses and a send identifier" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev.example.com ID"})
      res = CFG.db[:handler].first
      expect(res[:send_spec]).to eq("tcp://10.0.0.1:8989")
      expect(res[:recv_spec]).to eq("tcp://10.0.0.1:9898")
      expect(res[:send_ident]).to eq("dev.example.com ID")
    end
  
    it "turns nil into empty string when recv_ident is not set" do
      M2Config::Handler.new({ send_spec:"tcp://10.0.0.1:8989",
                              recv_spec:"tcp://10.0.0.1:9898",
                              send_ident: "dev.example.com ID"})
      res = CFG.db[:handler].first
      expect(res[:recv_ident]).to be_empty
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
      expect(M2Config::Handler.new({send_spec:"tcp://10.0.0.1:8988", recv_spec:"tcp://10.0.0.1:8989", send_ident: "dev.example.com ID"}).type).to eq("handler")
    end
  end
end
