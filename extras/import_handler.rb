module ImportHandler
  def method_missing(name, code)
    name = name.to_s.chomp("=").to_sym
    if name =~ /_lookup_code$/
      case name
        when :thin_ice_lookup_code
          assign_lookup(:ice_lookup, code, :thin_ice_lookup)
        when :thick_ice_lookup_code
          assign_lookup(:ice_lookup, code, :thick_ice_lookup)
        else
          lookup_model = name.to_s.gsub(/_code$/, '')

          assign_lookup(lookup_model, code)
      end
    else
      super
    end
  end

  def assign_lookup(name, code, param = nil)
    param = name if param.nil?
    self.send("#{param}=", name.to_s.classify.constantize.where(code: code).first)
  end

  module ClassMethods
    def import( attrs )
      model = self.new
      attrs.each do |attr, value|
        if( attr =~ /_attributes$/)
          lookup_model = attr.to_s.gsub(/_attributes$/, '')
          attr = attr.to_s.chomp("_attributes")
          if value.is_a? Array
            res = []
            value.each do |v|
              res << lookup_model.to_s.classify.constantize.import(v)
            end
          else
            res = lookup_model.to_s.classify.constantize.import(value)
          end
          value = res
        end
        ap "#{model}.send('#{attr}=',#{value})"
        model.send("#{attr}=", value)
        ap 0000000000000000000000000
        ap model.inspect

        ap 1111111111111111111111111
      end
      model
    end
  end


  def self.included(base)
    base.extend(ClassMethods)
  end
end