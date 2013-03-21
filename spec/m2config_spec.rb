require "env"
  
TABLES = %w(directory handler host log mimetype proxy route server setting statistic)

File.delete EXISTING_DB_NAME rescue nil
emptyDB = SQLite3::Database.new EXISTING_DB_NAME

describe M2Config do
  
  before(:each) do
    File.delete DEFAULT_DB_NAME rescue nil
    File.delete CUSTOM_DB_NAME rescue nil
    @cfg = M2Config::Config.new
  end
  
  after(:each) do
    @db.close if @db && !@db.closed?
  end  
  
  it 'creates a default database when name absent' do
    File.should exist DEFAULT_DB_NAME
  end
  
  it 'can create the database in a specific file' do
    @cfg = M2Config::Config.new CUSTOM_DB_NAME
    File.should exist CUSTOM_DB_NAME
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
  
  it 'does not change the schema if the database file pre-exists' do
    @cfg = M2Config::Config.new EXISTING_DB_NAME
    expect {emptyDB.execute("SELECT * FROM server;")}.to raise_error
  end
  
  describe '#[]=' do
    
    it 'creates or modifies the value of a setting' do
      db = SQLite3::Database.new DEFAULT_DB_NAME
      db.results_as_hash = true
      @cfg["zeromq.threads"] = 8
      res = db.get_first_row("SELECT * FROM setting WHERE key=?;", "zeromq.threads")
      res["value"].should eq("8")
    end
    
  end
  

end

