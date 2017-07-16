#### Create database
CREATE DATABASE IF NOT EXISTS mydb;

### Use database
USE mydb;

################## Create Managed table ########################
CREATE TABLE IF NOT EXISTS mydb.employees (
name STRING COMMENT 'Employee name',
salary FLOAT COMMENT 'Employee salary',
subordinates ARRAY<STRING> COMMENT 'Names of subordinates',
deductions MAP<STRING, FLOAT> COMMENT 'Keys are deductions names, values are percentages',
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT> COMMENT 'Home address'
)
COMMENT 'Description of the table';

#### Create table (by copying existing table structure)
CREATE TABLE IF NOT EXISTS mydb.employees2
LIKE mydb.employees;

#### Verify tables
SHOW tables;

#### Describe employees table
describe formatted employees;

/*****************************************************************************************
# col_name            	data_type           	comment             
	 	 
name                	string              	Employee name       
salary              	float               	Employee salary     
subordinates        	array<string>       	Names of subordinates
deductions          	map<string,float>   	Keys are deductions names, values are percentages
address             	struct<street:string,city:string,state:string,zip:int>	Home address        
	 	 
# Detailed Table Information	 	 
Database:           	mydb                	 
Owner:              	cloudera            	 
CreateTime:         	Sat Jul 15 23:52:15 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/mydb.db/employees	 
Table Type:         	MANAGED_TABLE       	 
Table Parameters:	 	 
	comment             	Description of the table
	transient_lastDdlTime	1500187935          
	 	 
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
Time taken: 0.115 seconds, Fetched: 31 row(s)
*****************************************************************************************/

