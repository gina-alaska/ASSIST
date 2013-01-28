#!/bin/bash

export JRUBY_OPTS="--1.9"
export RAILS_ENV="production"
unset BUNDLE_GEMFILE

git submodule init
git submodule update
bundle
rake package:metadata["$1","$2"]
rake db:setup
rake assets:precompile
bundle exec warble executable war 

DATE=`date "+%Y%m%d"`
PKGNAME="ASSIST_$1_$DATE"
rake package:generate_zip[$PKGNAME]