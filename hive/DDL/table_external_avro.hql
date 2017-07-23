#################################### Sqoop : Import table - START ##########################################

###### Import table as avro file
sqoop import \
--connect jdbc:mysql://localhost/sqoop_db \
--username sqoop \
--password sqoop \
--table cities \
--num-mappers 1 \
--target-dir /user/cloudera/sqoop_test/cities-avro \
--as-avrodatafile

###### Extract avro schema from avro file
avro-tools getschema hdfs://quickstart.cloudera/user/cloudera/sqoop_test/cities-avro/part-m-00000.avro > cities.avsc

###### Copy avro schema to HDFS
hadoop fs -mkdir /user/cloudera/avro_schema
hadoop fs -put cities.avsc /user/cloudera/avro_schema

#################################### Sqoop : Import table - END ##########################################


#### Create database
hive
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

#################################### External table (using AVRO file) - START ##########################################

#### Create External table
CREATE EXTERNAL TABLE IF NOT EXISTS cities_avro
STORED AS AVRO
LOCATION '/user/cloudera/sqoop_test/cities-avro'
TBLPROPERTIES ('avro.schema.url'='/user/cloudera/avro_schema/cities.avsc');

### Describe stocks table
describe formatted cities_avro;

/********************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
id                  	bigint              	                    
country             	string              	                    
city                	string              	                    
	 	 
# Detailed Table Information	 	 
Database:           	mydb                	 
Owner:              	cloudera            	 
CreateTime:         	Sun Jul 23 03:17:08 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/cloudera/sqoop_test/cities-avro	 
Table Type:         	EXTERNAL_TABLE      	 
Table Parameters:	 	 
	COLUMN_STATS_ACCURATE	false               
	EXTERNAL            	TRUE                
	avro.schema.url     	/user/cloudera/avro_schema/cities.avsc
	numFiles            	0                   
	numRows             	-1                  
	rawDataSize         	-1                  
	totalSize           	0                   
	transient_lastDdlTime	1500805028          
	 	 
# Storage Information	 	 
SerDe Library:      	org.apache.hadoop.hive.serde2.avro.AvroSerDe	 
InputFormat:        	org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat	 
OutputFormat:       	org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat	 
Compressed:         	No                  	 
Num Buckets:        	-1                  	 
Bucket Columns:     	[]                  	 
Sort Columns:       	[]                  	 
Storage Desc Params:	 	 
	serialization.format	1                   
Time taken: 0.125 seconds, Fetched: 35 row(s)
************************************************************************************************/

#################################### External table (using AVRO file) - END ##########################################


