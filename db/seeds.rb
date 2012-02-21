# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#TODO: ridge_type
%w{
algae_distribution
animal_type
biota_type
cloud_type
floe_size
ice_discoloration
ice_field_type
ice_type
ice_obs_type
melt_pond_max_depth
melt_pond_pattern
melt_pond_surface_type
on_boat_location
open_water_type
progress_type
region_type
sea_state
sediment_type
snow_obs_type
snow_type
topography_type
visibility_type
weather_type
}.each do |file|
  puts file
  eval(file.camelcase).delete_all
  YAML.load_file("db/#{file}s.yml").each do |record|
    eval(file.camelcase).create( record )
  end
end
