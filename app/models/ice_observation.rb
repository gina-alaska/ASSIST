class IceObservation < ActiveRecord::Base
  belongs_to :observation
  has_one :melt_pond
  has_one :topography
  belongs_to :ice_lookup

  accepts_nested_attributes_for :melt_pond
  accepts_nested_attributes_for :topography


end
