json.(melt_pond, :surface_coverage, :freeboard, :dried_ice, :rotten_ice)

json.max_depth_lookup_code melt_pond.max_depth_lookup.code unless melt_pond.max_depth_lookup.nil?
json.pattern_lookup_code melt_pond.pattern_lookup.code unless melt_pond.pattern_lookup.nil?
json.surface_lookup_code melt_pond.surface_lookup.code unless melt_pond.surface_lookup.nil?
json.bottom_type_lookup_code melt_pond.bottom_type_lookup.code unless melt_pond.bottom_type_lookup.nil?
