module M2Config
  class Host < Sequel::Model(:host)
    plugin :validation_helpers
  
    def initialize( fields )
      s = resolveServer fields
      fields[:server_id] = s.id if s
      raise ArgumentError, "Name can not be nil" if fields[:name].nil?
      super fields, false
      save
    end
  
    def add_route( route )
      route.host = id
    end

    private
    
    def resolveServer( fields )
      if fields[:srv]
        s=fields[:srv]
        fields.delete :srv
      else
        if fields[:srvUuid]
          s=Server.find({uuid: fields[:srvUuid]})
          fields.delete :srvUuid
        end
      end
      s
    end

  
  end
end
