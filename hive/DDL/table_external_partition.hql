#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

##################### Create External table (With partition) ######################
CREATE EXTERNAL TABLE IF NOT EXISTS log_messages (
hms INT,
severity STRING,
server STRING,
process_id INT,
message STRING)
PARTITIONED BY (year INT, month INT, day INT)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t';

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
CreateTime:         	Sun Jul 16 06:33:04 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/mydb.db/log_messages	 
Table Type:         	EXTERNAL_TABLE      	 
Table Parameters:	 	 
	EXTERNAL            	TRUE                
	transient_lastDdlTime	1500211984          
	 	 
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
Time taken: 0.104 seconds, Fetched: 39 row(s)
*****************************************************************************************************/

#### Add partition from hdfs location
ALTER TABLE log_messages 
ADD PARTITION(year = 2017, month = 7, day = 15)
LOCATION '/user/cloudera/data/log_message/2017/07/15';

#### Show partitions
SHOW PARTITIONS log_messages;

/********************************************************************************
OK
year=2017/month=7/day=15
Time taken: 0.147 seconds, Fetched: 1 row(s)
********************************************************************************/
