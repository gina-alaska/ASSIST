source 'https://rubygems.org'

gem 'rails', '~> 3.2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if RUBY_PLATFORM == 'java'
  gem 'warbler'
  gem 'activerecord-jdbcsqlite3-adapter', '~> 1.3.4', :require => false
  gem 'jdbc-sqlite3', '3.7.2'
  gem 'jruby-openssl'
else
  gem 'sqlite3'
end

gem 'assist-shared', '0.2.7', git: 'http://github.com/gina-alaska/iceobs-shared', require: 'assist_shared'

gem 'haml'

gem 'rubyzip', require: "zip/zipfilesystem"
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' unless RUBY_PLATFORM == 'java'

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'meta_request'
end

gem 'sass-rails',   '~> 3.2.3'
gem 'bootstrap-sass', '~> 2.1.0.0'
gem 'bootstrap-datepicker-rails'

gem 'jquery-rails'
gem 'active_attr'
#gem 'awesome_print', :git => "https://github.com/ceromancy/awesome_print.git"
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder'
gem 'nested_form'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
# gem 'wicked'
gem 'bower-tools', git: 'https://github.com/gina-alaska/bower-tools.git'
