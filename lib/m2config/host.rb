module M2Config
  class Host < Sequel::Model(:host)
    one_to_many :routes
  
    def initialize( fields )
      s = resolveServer fields
      fields[:server_id] = s.id if s
      raise ArgumentError, "Name can not be nil" if fields[:name].nil?
      super fields, false
      save
    end
  
    def check_routes
      paths = routes.map { |route| route[:path] }
      paths.uniq.size == paths.size
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
