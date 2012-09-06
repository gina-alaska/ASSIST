# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# %w{
# algae_distribution_lookup
# animal_lookup
# biota_lookup
# cloud_lookup
# floe_size_lookup
# ice_discoloration_lookup
# ice_lookup
# max_depth_lookup
# pattern_lookup
# surface_lookup
# on_boat_location_lookup
# open_water_lookup
# progress_lookup
# region_lookup
# sea_state_lookup
# sediment_lookup
# snow_lookup
# topography_lookup
# visibility_lookup
# weather_lookup
# }.each do |file|
#   puts file
#   eval(file.camelcase).delete_all
#   YAML.load_file("db/#{file}s.yml").each do |record|
#     eval(file.camelcase).create( record )
#   end
# end

Dir.glob(Rails.root.join("db/lookups","*.yaml")).each do |lookup|
  puts "Lookup: #{lookup}"
  table = File.basename(lookup, "s.yaml").camelcase.constantize
  table.delete_all
  
  YAML.load_file(lookup).each do |record|
    table.create(record)
  end
end