module AssistShared
  module Validations
    module Ice
      extend ActiveSupport::Concern
      include ActiveModel::Validations 
      
      included do
        validates_presence_of :total_concentration
        validates :total_concentration, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
        
        validates_with ::AssistShared::Validations::LookupCodeValidator, 
                        fields: { thin_ice_lookup_id: "ice_lookup", thick_ice_lookup_id: "ice_lookup", open_water_lookup_id: "open_water_lookup"}, 
                        allow_blank: true
  
      end
      
      
    end
  end
end