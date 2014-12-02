require "mime/types"
require "yaml"
  
module M2Config
  class MimeType < Sequel::Model(:mimetype)

    MONGREL2_PREFS = YAML.load File.read "#{File.dirname(__FILE__)}/mongrel2.mime.yml"
    RECESSIVE = YAML.load File.read "#{File.dirname(__FILE__)}/mongrel2.mime.yml"
    SQL_FIND_DUPLICATES = <<-SQL
                             select mimetype, extension, count(*)
                             from mimetype
                             group by extension
                             having count(*)>1
                             SQL
  
    def self.populate_table
      raise RuntimeError, "Table must be empty" if db[:mimetype].count > 0
      rows = []
      MIME::Types.each {
        |type|
        next if not_dominant?(type)
        type.extensions.each {
          |ext|
          ext = "."+ext
          clashingType = M2Config::MimeType[extension:ext]
          raise ArgumentError, "extension #{ext} is already covered by #{clashingType.mimetype} type" if clashingType
          rows << [type.content_type, ext]
        }
      }
      db.transaction {
        db[:mimetype].import([:mimetype, :extension], rows)
      }
      remove_duplicates
    end
  
    # Is it reasonable to ignore this type ?
    def self.not_dominant?(mtype)
      mtype.obsolete? || superceded?(mtype)  || !simplest?(mtype)
    end

    def self.superceded?( mtype )
      mtype.docs =~ /instead/
    end
  

    def self.simplest?(mtype)
      mtype.content_type == mtype.simplified
    end
    def self.remove_duplicates
      db[SQL_FIND_DUPLICATES].all.each {
        |r|
        ext = r[:extension]
        preferred = MONGREL2_PREFS[ext]
        if preferred
          db[:mimetype].where(extension:ext).delete
          db[:mimetype].insert(extension:ext, mimetype:preferred)
        else
          raise ArgumentError, "#{ext} has multiple content types but no Mongrel2 preference"
        end
      }
      raise RuntimeError, "Still duplicates after removing duplicates!" if
        db[SQL_FIND_DUPLICATES].all.size > 0
    end
    
    def initialize( fields )
      raise ArgumentError, "Extension must start with a ." unless fields[:extension] =~ /^\./
      type = M2Config::MimeType[extension:fields[:extension]]
      raise ArgumentError, "extension #{fields[:extension]} is already covered by #{type.mimetype} type" if type
      super(fields, false)
      save
    end
  
  end
end
