#!/bin/bash
java -Ddb=`pwd`/production.sqlite3 -Dexport=`pwd`/observations -jar ASSIST.war
