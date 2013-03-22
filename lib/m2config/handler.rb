module M2Config
  class Handler < Sequel::Model(:handler)
    plugin :validation_helpers
  
    def initialize( fields )
      raise ArgumentError, "The send and receive endpoints can not be the same" if
        fields[:send_spec] == fields[:recv_spec]
      fields[:recv_ident] ||= ""
      super(fields, false)
      save
    end
  
    def type
      "handler"
    end
  
  end
end
