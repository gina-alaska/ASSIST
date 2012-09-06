require 'open-uri'
require 'json'

namespace :package do
  desc "Update lookup yaml files"
  task :update_lookups do
    params = Hash.new
    #Get the lookup data and populate the database
    lookups_url = params[:lookups] || "http://icebox.dev/api/lookups.json"
    
    lookups = JSON.parse(open(lookups_url).read)
    
    lookups.each do |lookup|
      File.open(Rails.root.join("db/lookups","#{lookup.first}.yaml"), "w") do |f|
        f << lookup.last.to_yaml
      end
    end 
  end
  
  desc "Generate static cruise data"
  task :metadata, :cruise_id, :ship_name do |t, args|
    cruise_id = args[:cruise_id] || "DEVELOPMENT"
    ship_name = args[:ship_name] || "DEVELOPMENT"
    File.open(Rails.root.join("config","initializers","cruises.rb"),"w") do |file|
      cruise = {id: cruise_id, ship: ship_name}
      file << "Cruise = #{cruise}"
    end    
  end

  desc "Generate zip file for distribution"
  task :generate_zip, :name do |t, args|
    name = args[:name] || "ASSIST"
    name = "#{name}.zip"
    
    system("zip -j #{name} assist.war vendor/launcher* db/production.sqlite3 doc/README.txt")
  end
end