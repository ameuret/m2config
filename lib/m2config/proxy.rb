module M2Config
  class Proxy < Sequel::Model(:proxy)
    plugin :validation_helpers
  
    def initialize( fields )
      super(fields, false)
      save
    end
  
    def type
      "proxy"
    end
  
  end
end
