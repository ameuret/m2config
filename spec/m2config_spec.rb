require "env"
  
TABLES = %w(directory handler host log mimetype proxy route server setting statistic filter)
  
describe M2Config do
  
  describe "::new" do
    it 'creates a default database when name absent' do
      expect(File).to exist DEFAULT_DB_NAME
    end
  
    it 'learns the DB schema from the official schema dump' do
      for table in TABLES do
        expect(M2Config::Config.tables).to include table
      end
    end
  
    it 'creates a valid database structure' do
      for table in M2Config::Config.tables do
        expect {CFG.db["SELECT * FROM #{table};"].first}.to_not raise_error
      end
    end
  
    it 'populates the MIME table with a nice set of mappings' do
      expect(M2Config::MimeType[extension:".html"].mimetype).to eq("text/html")
      expect(M2Config::MimeType[extension:".css"].mimetype).to eq("text/css")
    end
  end
  
  describe '#[]=' do
    it 'creates or modifies the value of a setting' do
      CFG["zeromq.threads"] = 8
      expect(CFG.db[:setting].where(key:"zeromq.threads").first[:value]).to eq("8")
    end
  end

end

