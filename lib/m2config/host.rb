module M2Config
  class Host < Sequel::Model(:host)
    plugin :validation_helpers
  
    def initialize( fields )
      if fields[:srv]
        s=fields[:srv]
        fields.delete :srv
      else
        if fields[:srvUuid]
          s=Server.find({uuid: fields[:srvUuid]})
          fields.delete :srvUuid
        end
      end
      fields[:server_id] = s.id if s
      super(fields, false)
      save
    end
  
    def add_route( route )
      route.host = id
    end

  
  end
end
