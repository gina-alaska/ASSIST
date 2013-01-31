module AssistShared
  module Validations
    module MeltPond
      extend ActiveSupport::Concern
      include ActiveModel::Validations 

      included do
        with_options allow_blank: true do |record|
          record.validates :surface_coverage, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
          record.validates :freeboard, numericality: {greater_than_or_equal_to: 0}
          
          record.validates_with ::AssistShared::Validations::LookupCodeValidator, fields: {max_depth_lookup: 'max_depth_lookup',
                                                                                    surface_lookup: 'surface_lookup', 
                                                                                    pattern_lookup: 'pattern_lookup'}
        end      
      end
    end
  end
end