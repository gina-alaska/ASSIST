class IceObservation < ActiveRecord::Base
  belongs_to :observation
  has_one :melt_pond
  has_one :topography

  accepts_nested_attributes_for :melt_pond
  accepts_nested_attributes_for :topography
end
