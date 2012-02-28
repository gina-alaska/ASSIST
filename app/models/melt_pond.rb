class MeltPond < ActiveRecord::Base
  belongs_to :ice_observation
  belongs_to :melt_pond_max_depth_lookup
  belongs_to :melt_pond_pattern_lookup
  belongs_to :metl_pond_surface_lookup
end
