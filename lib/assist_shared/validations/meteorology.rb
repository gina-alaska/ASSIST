module AssistShared
  module Validations
    module Meteorology
      extend ActiveSupport::Concern
      include ActiveModel::Validations 
      
      included do
        validates_with ::AssistShared::Validations::LookupCodeValidator, 
                        fields: {visibility_lookup_id: 'visibility_lookup', weather_lookup_id: 'weather_lookup'}, 
                        allow_blank: true
        
        # validates :cloud_heights, clouds.high, clouds.medium, ">"
        # 
        # def cloud_heights a, b, comparison
        #   valid = true
        #   unless a.cloud_height.nil? || b.cloud_height.nil?
        #     valid = a.send(b, comparison)
        #   end
        #   valid
        # end
        
        # def cloud_heights
        #   unless clouds.high.cloud_height.nil?
        #     if clouds.high.cloud_height < clouds.medium.cloud_height
        #       clouds.high.errors.add :cloud_height, "should be above the medium cloud height"
        #     end
        #     
        #     if clouds.high.cloud_height < clouds.low.cloud_height
        #       clouds.high.errors.add :cloud_height, "should be above the low cloud height"
        #     end
        #   end
        #   
        # end
      end
    end
  end
end