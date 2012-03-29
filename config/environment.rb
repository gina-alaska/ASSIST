# Load the rails application
require File.expand_path('../application', __FILE__)

if RUBY_PLATFORM == "java"
  puts "HI, I'm Java. I want to put things here:"
  puts java.lang.System.getProperty("export")
  EXPORT_DIR = java.lang.System.getProperty("export") || "public/observations"
else
  EXPORT_DIR = "public/observations"
end

# Initialize the rails application
Iceobs::Application.initialize!
