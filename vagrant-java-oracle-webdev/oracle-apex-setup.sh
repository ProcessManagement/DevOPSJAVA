#Technique from http://stackoverflow.com/a/16108372
sqlplus -s /nolog << EOF
CONNECT system/default;

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@/vagrant/oracle-apex-setup.sql

exit;
