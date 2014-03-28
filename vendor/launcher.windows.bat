@echo off

set DB=%~dp0/production.sqlite3
set EXPORT=%~dp0/observations
set JAR=%~dp0/ASSIST.war

java -Ddb="%DB%" -Dexport="%EXPORT%" -Xms1G -Xmx4G -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC -jar "%JAR%"
