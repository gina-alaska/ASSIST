class IceObservation < ActiveRecord::Base
  belongs_to :observation
  has_one :melt_pond
end
