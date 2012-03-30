# Load the rails application
require File.expand_path('../application', __FILE__)

if RUBY_PLATFORM == "java"
  EXPORT_DIR = java.lang.System.getProperty("export") || "public/observations"
else
  EXPORT_DIR = "public/observations"
end

# Initialize the rails application
Iceobs::Application.initialize!
