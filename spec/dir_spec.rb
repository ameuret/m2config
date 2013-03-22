require "env"

M2Config::Config.new # Dummy call to ensure that model classes are required (cf. M2Config::new)

describe M2Config::Dir do
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
    it "needs to know the base path to handle" do
      M2Config::Dir.new({base:"images/"})
      res= @db.get_first_row("SELECT * FROM directory;")
      res["base"].should eq("images/")
    end
    
    it "defaults to application/octet-stream for the default content type" do
      M2Config::Dir.new({base:"images/"})
      res= @db.get_first_row("SELECT * FROM directory;")
      res["default_ctype"].should eq("application/octet-stream")
    end
    
    it "defaults to index.html for the index file" do
      dir = M2Config::Dir.new({base:"/"})
      res= @db.get_first_row("SELECT * FROM directory;")
      res["index_file"].should eq("index.html")
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
      M2Config::Dir.new({base:"/"}).type.should eq("dir")
    end
  end

end
