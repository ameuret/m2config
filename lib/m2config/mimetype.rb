require "mime/types"
  
module M2Config
  class MimeType < Sequel::Model(:mimetype)

    def self.populate_table
      rows = []
      MIME::Types.each {
        |type|
        type.extensions.each {
          |ext|
          rows << [type.content_type, ext]
        }
      }
      db[:mimetype].import([:mimetype, :extension], rows)
    end
  
    def initialize( fields )
      super(fields, false)
      save
    end
  
  end
end
