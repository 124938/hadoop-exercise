#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

#################################### External table (With Partition) - START ##########################################

#### Create external table - with partition
CREATE EXTERNAL TABLE IF NOT EXISTS log_messages_par (
hms INT,
severity STRING,
server STRING,
process_id INT,
message STRING)
PARTITIONED BY (year INT, month INT, day INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

#### Add partition from HDFS location
ALTER TABLE log_messages_par ADD IF NOT EXISTS
PARTITION (year = 2017, month = 7, day = 15) LOCATION '/user/cloudera/data/log_message/2017/07/15'
PARTITION (year = 2017, month = 7, day = 16) LOCATION '/user/cloudera/data/log_message/2017/07/16'
PARTITION (year = 2017, month = 7, day = 17) LOCATION '/user/cloudera/data/log_message/2017/07/17';

#### Execute query
select * from log_messages_par;
select * from log_messages_par where year=2017;
select * from log_messages_par where year=2017 and month=7;
select * from log_messages_par where year=2017 and month=7 and day=17;

#### Show partitions
show partitions log_messages_par;

/********************************************************************************
OK
year=2017/month=7/day=15
year=2017/month=7/day=16
year=2017/month=7/day=17
Time taken: 0.147 seconds, Fetched: 3 row(s)
********************************************************************************/

#### Describe table with all details
describe formatted log_messages_par;

/****************************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
hms                 	int                 	                    
severity            	string              	                    
server              	string              	                    
process_id          	int                 	                    
message             	string              	                    
	 	 
# Partition Information	 	 
# col_name            	data_type           	comment             
	 	 
year                	int                 	                    
month               	int                 	                    
day                 	int                 	                    
	 	 
# Detailed Table Information	 	 
Database:           	mydb                	 
Owner:              	cloudera            	 
CreateTime:         	Sun Jul 23 08:40:22 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/mydb.db/log_messages	 
Table Type:         	EXTERNAL_TABLE      	 
Table Parameters:	 	 
	EXTERNAL            	TRUE                
	transient_lastDdlTime	1500824422          
	 	 
# Storage Information	 	 
SerDe Library:      	org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe	 
InputFormat:        	org.apache.hadoop.mapred.TextInputFormat	 
OutputFormat:       	org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat	 
Compressed:         	No                  	 
Num Buckets:        	-1                  	 
Bucket Columns:     	[]                  	 
Sort Columns:       	[]                  	 
Storage Desc Params:	 	 
	field.delim         	\t                  
	serialization.format	\t                  
Time taken: 0.107 seconds, Fetched: 39 row(s)
*****************************************************************************************************/

#################################### External table (With Partition) - END ##########################################


