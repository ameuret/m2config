require "env"

describe M2Config::Route do
  
  describe "::new" do
    it "needs to know the path pattern and the target handler" do
      dirH = M2Config::Dir.new({base: "static/"})
      M2Config::Route.new({path:"/blog", target: dirH})
      res = CFG.db[:route].first
      expect(res[:path]).to eq("/blog")
      expect(res[:target_id]).to eq(dirH.id)
      expect(res[:target_type]).to eq(dirH.type)
    end
  end
  
  describe "::elect!" do
    it "makes a route the exclusive matcher for its path by deleting all other matching routes (on the same host)" do
      host = M2Config::Host.new({name:"main",matching:"actime.biz"})
      dirH = M2Config::Dir.new({base: "static/"})
      dir2 = M2Config::Dir.new({base: "ManceRayder/"})
      r1 = M2Config::Route.new({path:"/king", target: dirH, host: host})
      r2 = M2Config::Route.new({path:"/king", target: dir2, host: host})
      r3 = M2Config::Route.new({path:"/king", target: dirH, host: host})
      M2Config::Route.elect!(r2)
      expect(host.check_routes).to be_truthy
      king = M2Config::Route.where(path: "/king").first
      expect(king.target.base).to eq("ManceRayder/")
    end

    it "leaves routes belonging to a different host untouched" do
      host = M2Config::Host.new({name:"main",matching:"actime.biz"})
      host2 = M2Config::Host.new({name:"secondary",matching:"nameforge.net"})
      dirH = M2Config::Dir.new({base: "static/"})
      dir2 = M2Config::Dir.new({base: "ManceRayder/"})
      r1 = M2Config::Route.new({path:"/king", target: dirH, host: host})
      r2 = M2Config::Route.new({path:"/king", target: dir2, host: host})
      r3 = M2Config::Route.new({path:"/king", target: dirH, host: host2})
      M2Config::Route.elect!(r2)
      expect(host.check_routes).to  be_truthy
      king = M2Config::Route.where(path: "/king").first
      expect(king.target.base).to eq("ManceRayder/")
      onOtherHost = M2Config::Route.where(path:"/king", target_id: dirH.id, host: host2).first
      expect(onOtherHost).not_to be_nil 
    end
  end
  
  describe "#host=" do
    it "can be used if the host is not known at creation" do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      dirH = M2Config::Dir.new({base: "static/"})
      r = M2Config::Route.new({path:"/blog", target: dirH})
      r.host = host.id
      res = CFG.db[:route].first
      expect(res[:host_id]).to eq(host.id)
    end
    
    it "can take a Host instance" do
      host = M2Config::Host.new({matching:"example.com", name: "ex"})
      dirH = M2Config::Dir.new({base: "static/"})
      r = M2Config::Route.new({path:"/blog", target: dirH})
      r.host = host
      res = CFG.db[:route].first
      expect(res[:host_id]).to eq(host.id)
    end
  end
  
  describe '#host' do # 
    it 'returns the associated Host object'  do
      dirH = M2Config::Dir.new({base: "static/"})
      r = M2Config::Route.new({path:"/blog", target: dirH})
      r.host = M2Config::Host.new({matching:"example.com", name: "ex"})
      expect(r.host.matching).to eq("example.com")
    end
  end

  describe '#target=' do
    it 'reassigns the target object' do
      dirH = M2Config::Dir.new({base: "static/"})
      r = M2Config::Route.new({path:"/blog", target: dirH})
      newTarget = M2Config::Proxy.new({addr:"127.0.0.1", port: 15970})
      r.target = newTarget
      res = CFG.db[:route].first
      expect(res[:target_id]).to eq(newTarget.id)
      expect(res[:target_type]).to eq(newTarget.type)
    end
  end
  
  describe '#target' do
    it 'returns the Target object' do
      dirH = M2Config::Dir.new({base: "static/"})
      r = M2Config::Route.new({path:"/blog", target: dirH})
      expect(r.target.base).to eq dirH.base
    end
  end

end
