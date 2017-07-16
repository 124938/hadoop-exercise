#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

################## Create Managed table (with partition) ########################
CREATE TABLE employees_par (
name STRING,
salary FLOAT,
subordinates ARRAY<STRING>,
deductions MAP<STRING, FLOAT>,
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
)
PARTITIONED BY (country STRING, state STRING);

#### Describe employees_par table
describe formatted employees_par;

/****************************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
name                	string              	                    
salary              	float               	                    
subordinates        	array<string>       	                    
deductions          	map<string,float>   	                    
address             	struct<street:string,city:string,state:string,zip:int>	                    
	 	 
# Partition Information	 	 
# col_name            	data_type           	comment             
	 	 
country             	string              	                    
state               	string              	                    
	 	 
# Detailed Table Information	 	 
Database:           	mydb                	 
Owner:              	cloudera            	 
CreateTime:         	Sun Jul 16 03:30:36 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/mydb.db/employees_par	 
Table Type:         	MANAGED_TABLE       	 
Table Parameters:	 	 
	transient_lastDdlTime	1500201036          
	 	 
# Storage Information	 	 
SerDe Library:      	org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe	 
InputFormat:        	org.apache.hadoop.mapred.TextInputFormat	 
OutputFormat:       	org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat	 
Compressed:         	No                  	 
Num Buckets:        	-1                  	 
Bucket Columns:     	[]                  	 
Sort Columns:       	[]                  	 
Storage Desc Params:	 	 
	serialization.format	1                   
Time taken: 0.115 seconds, Fetched: 36 row(s)
*****************************************************************************************************/

############################## Load data into partition #########################################
LOAD DATA LOCAL INPATH '${env:HOME}/hive/employees.txt'
INTO TABLE employees_par
PARTITION (country = 'US', state = 'CA');

#### Verify data
!hadoop fs -ls -R /user/hive/warehouse/mydb.db/employees_par;

/*******************************************************************************************************************************************
drwxrwxrwx   - cloudera supergroup          0 2017-07-16 03:57 /user/hive/warehouse/mydb.db/employees_par/country=US
drwxrwxrwx   - cloudera supergroup          0 2017-07-16 03:57 /user/hive/warehouse/mydb.db/employees_par/country=US/state=CA
-rwxrwxrwx   1 cloudera supergroup        784 2017-07-16 03:57 /user/hive/warehouse/mydb.db/employees_par/country=US/state=CA/employees.txt
*******************************************************************************************************************************************/

#### Describe employees_par table
SHOW PARTITIONS employees_par;

/*******************************************
OK
country=US/state=CA
Time taken: 0.101 seconds, Fetched: 1 row(s)
*******************************************/

############################## Execute query #########################################
SELECT e.name, e.salary, e.subordinates
FROM employees_par e
WHERE e.country='US' and e.state='CA';

/***************************************************************************************
OK
John Doe	100000.0	["Mary Smith","Todd Jones"]
Mary Smith	80000.0	["Bill King"]
Todd Jones	70000.0	[]
Bill King	60000.0	[]
Boss Man	200000.0	["John Doe","Fred Finance"]
Fred Finance	150000.0	["Stacy Accountant"]
Stacy Accountant	60000.0	[]
Time taken: 0.105 seconds, Fetched: 7 row(s)
***************************************************************************************/

#### Verify tables
SHOW tables;

