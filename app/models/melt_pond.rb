class MeltPond < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::MeltPond
  include AssistShared::Validations::MeltPond
  
  belongs_to :ice_observation
  belongs_to :max_depth_lookup
  belongs_to :pattern_lookup
  belongs_to :surface_lookup


  def as_json opts={}
    super except: [:id, :created_at, :updated_at, :ice_observation_id]
  end
 
end
