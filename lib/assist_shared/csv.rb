module AssistShared
  module CSV
    AssistShared::CSV.autoload :LookupCodeValidator, 'assist_shared/csv/lookup_code_validator'
    AssistShared::CSV.autoload :Observation,'assist_shared/csv/observation'
    AssistShared::CSV.autoload :Ice,'assist_shared/csv/ice'
    AssistShared::CSV.autoload :IceObservation, 'assist_shared/csv/ice_observation'
    AssistShared::CSV.autoload :Cloud, 'assist_shared/csv/cloud'
    AssistShared::CSV.autoload :MeltPond, 'assist_shared/csv/melt_pond'
    AssistShared::CSV.autoload :Meteorology, 'assist_shared/csv/meteorology'
    AssistShared::CSV.autoload :Topography, 'assist_shared/csv/topography'
  end
end
 