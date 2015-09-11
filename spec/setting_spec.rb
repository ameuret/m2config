# -*- coding: utf-8 -*-
require "env"

describe M2Config::Setting do
  
  describe "::new" do
    it "stores the given value under the given key" do
      M2Config::Setting.new("answer",42)
      res = CFG.db[:setting].first
      expect(res[:value]).to eq("42")
    end
  
    it "updates the existing value if the given key is already present" do
      M2Config::Setting.new("answer",41)
      M2Config::Setting.new("answer",42)
      res = CFG.db[:setting].first
      expect(res[:value]).to eq("42")
    end
  end    
end
