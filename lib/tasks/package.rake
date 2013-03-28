require 'open-uri'
require 'json'

namespace :package do  
  desc "Generate static cruise data"
  task :metadata, :cruise_id, :ship_name, :lookups do |t, args|
    #Get the lookup data and populate the database
    lookups_url = args[:lookups] || "http://icewatch.gina.alaska.edu/api/lookups.json"
    
    lookups = JSON.parse(open(lookups_url).read)
    
    lookups.each do |lookup|
      File.open(Rails.root.join("db/lookups","#{lookup.first}.yaml"), "w") do |f|
        f << lookup.last.to_yaml
      end
    end 
    
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
    puts Dir.glob("*").inspect
    system("zip -j #{name} ASSIST.war vendor/launcher* db/production.sqlite3 doc/README.txt")
  end
  
  desc "Run all package steps to produce a distributable zip"
  task :all, :cruise_id, :ship_name, :zip_name do |t, args|
    cruise_id = args[:cruise_id] || "DEVELOPMENT"
    ship_name = args[:ship_name] || "DEVELOPMENT"
    zip_name = args[:zip_name] || "ASSIST"
    Rake::Task["package:update_lookups"].invoke
    Rake::Task["package:metadata"].invoke(cruise_id, ship_name)
    Rake::Task["package:generate_zip"].invoke(zip_name)
  end
end
