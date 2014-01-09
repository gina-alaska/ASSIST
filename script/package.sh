#!/bin/bash

export JRUBY_OPTS="--1.9"
export RAILS_ENV="production"
unset BUNDLE_GEMFILE

bundle
bundle exec rake package:metadata["$1","$2"]
bundle exec rake db:setup
bundle exec rake assets:precompile
bundle exec warble executable war 

DATE=`date "+%Y%m%d"`
PKGNAME="ASSIST_$DATE"
bundle exec rake package:generate_zip[$PKGNAME]

#Clean up assets and database
rm db/production.sqlite3
rm -rf public/assets
