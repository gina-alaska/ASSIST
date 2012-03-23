class IceObservation < ActiveRecord::Base
  include ImportHandler

  belongs_to :observation
  has_one :melt_pond, :dependent => :destroy
  has_one :topography, :dependent => :destroy
  belongs_to :ice_lookup
  belongs_to :floe_size_lookup
  belongs_to :sediment_lookup
  belongs_to :biota_lookup
  belongs_to :snow_lookup

  accepts_nested_attributes_for :melt_pond
  accepts_nested_attributes_for :topography



end
