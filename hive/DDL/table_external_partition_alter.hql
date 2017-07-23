#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

#################################### External table (With Partition) - ALTER - START ##########################################

#### Create external table
CREATE EXTERNAL TABLE IF NOT EXISTS log_messages_tmp (
hms INT,
severity STRING,
server STRING,
process_id INT,
message STRING)
PARTITIONED BY (year INT, month INT, day INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

#### Rename table 
ALTER TABLE log_messages_tmp RENAME TO logmsgs_tmp;

#### Rename column
ALTER TABLE logmsgs_tmp
CHANGE COLUMN hms hours_minutes_seconds INT
COMMENT 'The hours, minutes, and seconds part of the timestamp';

#### Add column
ALTER TABLE logmsgs_tmp ADD COLUMNS (
app_name STRING COMMENT 'Application name',
session_id INT COMMENT 'The current session id');

#### Add properties on table
ALTER TABLE logmsgs_tmp SET TBLPROPERTIES ('notes' = 'The process id is no longer captured; this column is always NULL');

#### describe table with all available details
describe formatted logmsgs_tmp;

#################################### External table (With Partition) - ALTER - END ##########################################

