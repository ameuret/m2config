require 'env'

describe M2Config::MimeType do
  
  describe '::new' do
    it 'reminds you that Mongrel2 wants the extension string to start with a .' do
      expect {
        M2Config::MimeType.new(extension:'bs', mimetype:'text/bullshit')
      }.to raise_exception(ArgumentError, /extension must start with a \./i) 
    end
  
    it 'yells when you try to insert duplicate extensions' do
      expect {
        M2Config::MimeType.new(extension:'.css', mimetype:'text/better-css')
      }.to raise_exception(ArgumentError, /extension .css is already covered by text\/css type/i) 
    end
  
    it 'allows you to force the redefinition of an existing extension' do
      pending
    end
  end
  
  describe '::populate_table' do
    it 'fills up the extension to MIME type mapping table' do
      # Clear entire table
      CFG.db[:mimetype].delete
      M2Config::MimeType.populate_table
      M2Config::MimeType[extension:'.css'].mimetype.should eq('text/css')
    end
  
    it 'frowns when asked to populate a non-empty table' do
      # At this point the table has been filled up on creation
      expect {
        M2Config::MimeType.populate_table
      }.to raise_exception(RuntimeError, /table must be empty/i) 
    end
  end
  
end
