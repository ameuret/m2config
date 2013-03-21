module M2Config
  class Route < Sequel::Model(:route)
    plugin :validation_helpers
  
    def initialize( fields )
      fields[:target_id] = fields[:target].id
      fields[:target_type] = fields[:target].type
      fields.delete(:target)
      super(fields, false)
      save
    end
  
    def host=( hostOrId )
      self.host_id = hostOrId.kind_of?(Host) ? hostOrId.id : hostOrId
      save
    end
  
  end
end
