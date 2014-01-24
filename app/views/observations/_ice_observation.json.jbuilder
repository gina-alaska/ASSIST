json.(ice_observation, :obs_type, :partial_concentration, :thickness, :snow_thickness)

json.floe_size_lookup_code ice_observation.floe_size_lookup.code unless ice_observation.floe_size_lookup.nil?
json.snow_lookup_code ice_observation.snow_lookup.code unless ice_observation.snow_lookup.nil?
json.biota_lookup ice_observation.biota_lookup.code unless ice_observation.biota_lookup.nil?
json.sediment_lookup ice_observation.sediment_lookup.code unless ice_observation.sediment_lookup.nil?

json.partial! 'observations/topography', topography_attributes: ice_observation.topography
json.partial! 'observations/melt_pond', melt_pond_attributes: ice_observation.melt_pond