#### Create database
CREATE DATABASE IF NOT EXISTS financials;
CREATE DATABASE human_resources;
CREATE DATABASE temp_db LOCATION '/user/cloudera/db/';

### Display available databases
SHOW DATABASES;

/************************************************
OK
default
financials
human_resources
temp_db
Time taken: 0.035 seconds, Fetched: 4 row(s)
************************************************/

### Describe financials database
describe database financials;

/********************************************************************************************************************
OK
financials		hdfs://quickstart.cloudera:8020/user/hive/warehouse/financials.db	cloudera	USER	
Time taken: 0.041 seconds, Fetched: 1 row(s)
********************************************************************************************************************/

### Use financials database (with current db)
USE financials; 
set hive.cli.print.current.db=true;

### Drop database
drop database temp_db;

### Drop database (to drop all db objects underneith)
drop database temp_db cascade;

