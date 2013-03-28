# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Dir.glob(Rails.root.join("db/lookups","*.yaml")).each do |lookup|
  puts "Lookup: #{lookup}"
  table = File.basename(lookup, ".yaml").constantize
  table.delete_all
  
  YAML.load_file(lookup).each do |record|
    table.create(record)
  end
end
