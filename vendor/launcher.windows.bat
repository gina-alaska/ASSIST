@echo off

set DB=%~dp0/production.sqlite3
set EXPORT=%~dp0/observations
set JART=%~dp0/ASSIST.war

java -Ddb="%DB%" -Dexport="%EXPORT%" -jar "%JAR%"
