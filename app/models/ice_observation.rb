class IceObservation < ActiveRecord::Base
  include ImportHandler
  include AssistShared::CSV::IceObservation
  include AssistShared::Validations::IceObservation

  belongs_to :observation
  has_one :melt_pond, :dependent => :destroy
  has_one :topography, :dependent => :destroy
  belongs_to :ice_lookup
  belongs_to :floe_size_lookup
  belongs_to :sediment_lookup
  belongs_to :biota_lookup
  belongs_to :biota_density_lookup
  belongs_to :snow_lookup
  belongs_to :biota_location_lookup

  accepts_nested_attributes_for :melt_pond
  accepts_nested_attributes_for :topography


  before_create do |obs|
    obs.topography = Topography.new if obs.topography.nil?
    obs.melt_pond = MeltPond.new if obs.melt_pond.nil?
  end

  def as_json opts={}
    data = super except: [:id, :updated_at, :created_at, :observation_id]
    data[:melt_pond_attributes] = melt_pond.as_json
    data[:topography_attributes] = topography.as_json
    data

  end
end
