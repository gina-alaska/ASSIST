#!/bin/bash

git submodule init
git submodule update
bundle install
rake package:metadata["$1","$2"]
rake db:migrate
rake db:seed
rake assets:precompile
warble executable war

DATE=`date "+%Y%m%d"`
PKGNAME="ASSIST_$1_$DATE"
rake package:generate_zip[$PKGNAME]