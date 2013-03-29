module M2Config
  class Host < Sequel::Model(:host)
    one_to_many :routes, {class: "M2Config::Route"}
  
    def initialize( fields )
      s = resolveServer fields
      fields[:server_id] = s.id if s
      raise ArgumentError, "Name can not be nil" if fields[:name].nil?
      super fields, false
      save
    end
  
    def check_routes
      paths = routes(true).map {
        |route|
        route.path
      }
#      return true if paths.empty?
      
#      return "#{paths.uniq.to_s} == #{paths.to_s}"
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
