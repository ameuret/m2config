module M2Config
  class Handler < Sequel::Model(:handler)
    plugin :validation_helpers
  
    ID_REGEX = /^[-a-zA-Z0-9]+$/
  
    def initialize( fields )
      raise ArgumentError, "The send and receive endpoints can not be the same" if
        fields[:send_spec] == fields[:recv_spec]
      raise ArgumentError, "Handler send and recv IDs must only use -a-zA-Z0-9" if
        !(fields[:send_ident] =~ ID_REGEX &&
         fields[:send_ident] =~ ID_REGEX)
      fields[:recv_ident] ||= ""
      super(fields, false)
      save
    end
  
    def type
      "handler"
    end
  
  end
end
