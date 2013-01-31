module AssistShared
  module Validations
    module IceObservation
      extend ActiveSupport::Concern
      include ActiveModel::Validations 
      
      included do
        with_options allow_blank: true do |record|
          record.validates :partial_concentration, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
          record.validates :thickness,  numericality: {only_integer: true, greater_than_or_equal_to: 0 }
          record.validates :snow_thickness,  numericality: {only_integer: true, greater_than_or_equal_to: 0 }
          record.validates :obs_type, inclusion: {in: %w(primary secondary tertiary)}
          record.validates_with LookupCodeValidator, fields: { ice_lookup: 'ice_lookup', 
                                                        floe_size_lookup: 'floe_size_lookup', 
                                                        snow_lookup: 'snow_lookup', 
                                                        biota_lookup: 'biota_lookup',
                                                        sediment_lookup: 'sediment_lookup'}
        end 
      end
    end
  end
end                                          