json.weather_lookup_code meteorology.weather_lookup.code unless meteorology.weather_lookup.nil?
json.visibility_lookup_code meteorology.visibility_lookup.code unless meteorology.visibility_lookup.nil?

json.cloud_attributes meteorology.clouds do |cloud|
  json.partial! cloud
end

json.(meteorology, :total_cloud_cover, :wind_speed, :air_temperature, 
                   :water_temperature, :relative_humidity, :air_pressure)