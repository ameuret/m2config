module M2Config
  class Dir < Sequel::Model(:directory)
    plugin :validation_helpers
  
    def initialize( fields )
      fields[:default_ctype] ||= "application/octet-stream"
      fields[:index_file] ||= "index.html"
      raise ArgumentError, "Base directories are relative to chroot and must not start with a slash (as in your <#{fields[:base]}>)" if 
        fields[:base] =~ /^\/.+/
      raise ArgumentError, "Base directories must end with a slash (your <#{fields[:base]}> does not)" if 
        !(fields[:base] =~ /\/$/)
      super(fields, false)
      save
    end
  
    def type
      "dir"
    end
  
  end
end
