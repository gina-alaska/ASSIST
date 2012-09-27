class Topography < ActiveRecord::Base
  include ImportHandler
  include AssistShared::Validations::Topography
  include AssistShared::CSV::Topography
  
  belongs_to :ice_observation
  belongs_to :topography_lookup

  def as_json opts={}
    super except: [:id, :created_at, :updated_at, :ice_observation_id]
  end

end
