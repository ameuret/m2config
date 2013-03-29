require "env"
  
TABLES = %w(directory handler host log mimetype proxy route server setting statistic filter)
  
describe M2Config do
  
  before(:all) do
  end
    
  after(:each) do
    @db.close if @db && !@db.closed?
  end  
  
  it 'creates a default database when name absent' do
    File.should exist DEFAULT_DB_NAME
  end
  
  it 'learns the DB schema from the official schema dump' do
    for table in TABLES do
      M2Config::Config.tables.should include table
    end
  end
  
  it 'creates a valid database structure' do
    @db = SQLite3::Database.new DEFAULT_DB_NAME
    for table in M2Config::Config.tables do
      expect {@db.execute("SELECT * FROM #{table};")}.to_not raise_error
    end
  end
  
  describe '#[]=' do
    it 'creates or modifies the value of a setting' do
      CFG["zeromq.threads"] = 8
      CFG.db[:setting].where(key:"zeromq.threads").first[:value].should eq("8")
    end
  end

end

