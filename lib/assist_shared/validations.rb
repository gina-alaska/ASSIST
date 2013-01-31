module AssistShared
  module Validations 
    extend ActiveSupport::Concern
     
    AssistShared::Validations.autoload :LookupCodeValidator, 'assist_shared/validations/lookup_code_validator'
    AssistShared::Validations.autoload :Observation,'assist_shared/validations/observation'
    AssistShared::Validations.autoload :Ice,'assist_shared/validations/ice'
    AssistShared::Validations.autoload :IceObservation, 'assist_shared/validations/ice_observation'
    AssistShared::Validations.autoload :Cloud, 'assist_shared/validations/cloud'
    AssistShared::Validations.autoload :MeltPond, 'assist_shared/validations/melt_pond'
    AssistShared::Validations.autoload :Meteorology, 'assist_shared/validations/meteorology'
    AssistShared::Validations.autoload :Topography, 'assist_shared/validations/topography'
    AssistShared::Validations.autoload :Shared, 'assist_shared/validations/shared'

  end
end