module M2Config
  class Setting < Sequel::Model(:setting)
    plugin :validation_helpers
  
    def initialize( key, value )
      if s=Setting[key:key] 
        s.update({value:value})
        return s
      else
        fields = {}
        fields[:key] = key.to_s
        fields[:value] = value.to_s
        super(fields, false)
        save
        return self
      end
    end
  end
end
