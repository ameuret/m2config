require "env"
  
TABLES = %w(directory handler host log mimetype proxy route server setting statistic filter)
  
describe M2Config do
  
  describe "::new" do
    it 'creates a default database when name absent' do
      File.should exist DEFAULT_DB_NAME
    end
  
    it 'learns the DB schema from the official schema dump' do
      for table in TABLES do
        M2Config::Config.tables.should include table
      end
    end
  
    it 'creates a valid database structure' do
      for table in M2Config::Config.tables do
        expect {CFG.db["SELECT * FROM #{table};"].first}.to_not raise_error
      end
    end
  
    it 'populates the MIME table with a nice set of mappings' do
      M2Config::MimeType[extension:".html"].mimetype.should eq("text/html")
      M2Config::MimeType[extension:".css"].mimetype.should eq("text/css")
    end
  end
  
  describe '#[]=' do
    it 'creates or modifies the value of a setting' do
      CFG["zeromq.threads"] = 8
      CFG.db[:setting].where(key:"zeromq.threads").first[:value].should eq("8")
    end
  end

end

