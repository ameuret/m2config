require "env"

describe M2Config::Dir do
  
  describe "::new" do
    it "needs to know the base path to handle" do
      M2Config::Dir.new({base:"images/"})
      expect(CFG.db[:directory].first[:base]).to eq("images/")
    end
    
    it "defaults to application/octet-stream for the default content type" do
      M2Config::Dir.new({base:"images/"})
      expect(CFG.db[:directory].first[:default_ctype]).to eq("application/octet-stream")
    end
    
    it "defaults to index.html for the index file" do
      dir = M2Config::Dir.new({base:"/"})
      expect(CFG.db[:directory].first[:index_file]).to eq("index.html")
    end
  
    describe "helps you spot common mistakes" do
      it "yells when the path contains a leading slash" do
        expect {
          M2Config::Dir.new({base:"/public"})
        }.to raise_exception(ArgumentError, /base directories are relative to chroot and must not start with a slash/i) 
      end
  
      it "yells when the path does not end with a slash" do
        expect {
          M2Config::Dir.new({base:"public"})
        }.to raise_exception(ArgumentError, /base directories must end with a slash/i) 
      end
  
      it "keeps calm with slashes inside the path" do
        expect { M2Config::Dir.new({base:"public/assets/"}) }.to_not raise_exception
      end
  
    end
  end
  
  describe '#type' do
    it 'returns its type' do
      expect(M2Config::Dir.new({base:"/"}).type).to eq("dir")
    end
  end

end
