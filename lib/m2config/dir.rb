module M2Config
  class Dir < Sequel::Model(:directory)
    plugin :validation_helpers
  
    def initialize( fields )
      fields[:default_ctype] ||= "application/octet-stream"
      fields[:index_file] ||= "index.html"
      super(fields, false)
      save
    end
  
    def type
      "dir"
    end
  
  end
end
