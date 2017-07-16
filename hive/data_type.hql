#### Create table
CREATE TABLE employees (
name STRING, 
salary FLOAT,
subordinates ARRAY<STRING>,
deductions MAP<STRING, FLOAT>,
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
);

#### Create table (with default parameter mentioned explicitly)
CREATE TABLE employees (
name STRING,
salary FLOAT,
subordinates ARRAY<STRING>,
deductions MAP<STRING, FLOAT>,
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001'
COLLECTION ITEMS TERMINATED BY '\002'
MAP KEYS TERMINATED BY '\003'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

##### Create table with comma saperated file
CREATE TABLE some_data (
first FLOAT,
second FLOAT,
third FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

#### Display all tables
SHOW tables;

/***************************************************************************************************
OK
employees
some_data
Time taken: 0.037 seconds, Fetched: 2 row(s)
***************************************************************************************************/

#### Describe employees table
describe employees;

/***************************************************************************************************
OK
name                	string              	                    
salary              	float               	                    
subordinates        	array<string>       	                    
deductions          	map<string,float>   	                    
address             	struct<street:string,city:string,state:string,zip:int>	                    
Time taken: 0.111 seconds, Fetched: 5 row(s)
***************************************************************************************************/

#### Describe employees table (with full details)
describe formatted employees;

/***************************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
name                	string              	                    
salary              	float               	                    
subordinates        	array<string>       	                    
deductions          	map<string,float>   	                    
address             	struct<street:string,city:string,state:string,zip:int>	                    
	 	 
# Detailed Table Information	 	 
Database:           	default             	 
Owner:              	cloudera            	 
CreateTime:         	Sat Jul 15 22:37:13 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/employees	 
Table Type:         	MANAGED_TABLE       	 
Table Parameters:	 	 
	transient_lastDdlTime	1500183433          
	 	 
# Storage Information	 	 
SerDe Library:      	org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe	 
InputFormat:        	org.apache.hadoop.mapred.TextInputFormat	 
OutputFormat:       	org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat	 
Compressed:         	No                  	 
Num Buckets:        	-1                  	 
Bucket Columns:     	[]                  	 
Sort Columns:       	[]                  	 
Storage Desc Params:	 	 
	colelction.delim    	\u0002              
	field.delim         	\u0001              
	line.delim          	\n                  
	mapkey.delim        	\u0003              
	serialization.format	\u0001              
Time taken: 0.103 seconds, Fetched: 34 row(s)
***************************************************************************************************/

#### Describe some_data table (with full details)
describe formatted some_data;

/***************************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
first               	float               	                    
second              	float               	                    
third               	float               	                    
	 	 
# Detailed Table Information	 	 
Database:           	default             	 
Owner:              	cloudera            	 
CreateTime:         	Sat Jul 15 22:54:09 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/hive/warehouse/some_data	 
Table Type:         	MANAGED_TABLE       	 
Table Parameters:	 	 
	transient_lastDdlTime	1500184449          
	 	 
# Storage Information	 	 
SerDe Library:      	org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe	 
InputFormat:        	org.apache.hadoop.mapred.TextInputFormat	 
OutputFormat:       	org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat	 
Compressed:         	No                  	 
Num Buckets:        	-1                  	 
Bucket Columns:     	[]                  	 
Sort Columns:       	[]                  	 
Storage Desc Params:	 	 
	field.delim         	,                   
	serialization.format	,                   
Time taken: 0.098 seconds, Fetched: 29 row(s)
***************************************************************************************************/


