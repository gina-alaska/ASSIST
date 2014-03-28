#!/bin/bash
java -Ddb=`pwd`/production.sqlite3 -Dexport=`pwd`/observations -Xms1G -Xmx4G -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -jar ASSIST.war
