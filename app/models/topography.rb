class Topography < ActiveRecord::Base
  include ImportHandler

  belongs_to :ice_observation
  belongs_to :topography_lookup

end
