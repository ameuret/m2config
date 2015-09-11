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
      fail
    end
  end
  
  describe '::populate_table' do
    it 'fills up the "extension -> MIME type" mapping table (using the list from https://github.com/halostatue/mime-types)' do
      # Clear entire table
      CFG.db[:mimetype].delete
      M2Config::MimeType.populate_table()
#      M2Config::MimeType.populate_table(nil,ignoreDoubles=true)
      M2Config::MimeType[extension:'.css'].mimetype.should eq('text/css')
    end
  
    it 'checks for doubles unless asked not to' do
      CFG.db[:mimetype].delete
      expect {
        M2Config::MimeType.populate_table([
                                           MIME::Type.new(['text/plain', 'zed']),
                                           MIME::Type.new(['text/complex', 'zed'])
                                          ])
      }.to raise_exception(ArgumentError,
                           /\.zed \(text\/complex\) has multiple content types but no Mongrel2 preference/i) 
    end
  
    it 'accepts an array of MIME::Types if the whole list is too much' do
      CFG.db[:mimetype].delete
      M2Config::MimeType.populate_table [MIME::Type.new(['text/plain', 'zed'])]
      M2Config::MimeType[extension:'.zed'].mimetype.should eq('text/plain')
      M2Config::MimeType[extension:'.css'].should eq(nil)
    end
  
    it 'frowns when asked to populate a non-empty table' do
      # At this point the table has been filled up on creation
      expect {
        M2Config::MimeType.populate_table
      }.to raise_exception(RuntimeError, /table must be empty/i) 
    end
  end
  
end
