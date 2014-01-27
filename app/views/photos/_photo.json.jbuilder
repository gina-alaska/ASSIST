json.on_boat_location_lookup_code photo.on_boat_location_lookup.code unless photo.on_boat_location_lookup.nil?
json.(photo, :name, :checksum, :note)