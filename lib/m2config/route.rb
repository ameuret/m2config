module M2Config
  class Route < Sequel::Model(:route)
    many_to_one :host
  
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
  
    def target=( newTarget )
      self.target_id = newTarget.id
      self.target_type = newTarget.type
      save
    end
  
    def target
      case target_type
      when "proxy" then Proxy[target_id]
      when "dir" then Dir[target_id]
      when "handler" then Handler[target_id]
      end
    end

  end
end
