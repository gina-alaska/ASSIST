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
    elsif name =~ /primary_observer$/
      code = code.split(" ");
      user = User.find_or_create_by_first_and_last_name(firstname: code.first, lastname: code.last)
      self.primary_observer= user
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
              res << self.reflections[lookup_model.to_sym].class_name.constantize.import(v)
             # res << lookup_model.to_s.classify.constantize.import(v)
            end
          else
            res = self.reflections[lookup_model.to_sym].class_name.constantize.import(value)
          end
          value = res
        end
        ap "#{model}.send('#{attr}=',#{value})"
        model.send("#{attr}=", value)
 
      end
      model
    end
  end


  def self.included(base)
    base.extend(ClassMethods)
  end
end