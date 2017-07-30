#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

#################################### Managed table (With Partition) - START ##########################################

#### Create Managed table to stage all employees data
CREATE TABLE employees_stage (
name STRING,
salary FLOAT,
subordinates ARRAY<STRING>,
deductions MAP<STRING, FLOAT>,
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>,
country STRING,
state STRING
);

#### Inserting Data into Tables from local file - this file contains employees data of all states
LOAD DATA LOCAL INPATH '${env:HOME}/hive/employees_stage.txt'
INTO TABLE employees_stage;

#### Execute query
select * from employees_stage;
select * from employees_stage where country = 'US' and state='CA';
select * from employees_stage where country = 'US' and state='IL';
select * from employees_stage where country = 'US' and state='OR';

#### Create managed table (with partition)
CREATE TABLE employees_par (
name STRING,
salary FLOAT,
subordinates ARRAY<STRING>,
deductions MAP<STRING, FLOAT>,
address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
)
PARTITIONED BY (country STRING, state STRING);

#### Inserting Data into Tables from Queries (Static partitioning)
INSERT INTO TABLE employees_par
PARTITION (country = 'US', state = 'CA')
SELECT se.name, se.salary, se.subordinates, se.deductions, se.address
FROM employees_stage se
WHERE se.country = 'US' AND se.state = 'CA';

#### Show partitions
show partitions employees_par;

/**********************************************
OK
country=US/state=CA
Time taken: 0.114 seconds, Fetched: 1 row(s)
**********************************************/

##### Enable dynamic partition feature - by default it is not allowed
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

#### Inserting Data into Tables from Queries (Dynamic partitioning)
INSERT INTO TABLE employees_par
PARTITION (country, state)
SELECT se.name, se.salary, se.subordinates, se.deductions, se.address, se.country, se.state
FROM employees_stage se
WHERE se.state != 'CA';

##### Show partitions
show partitions employees_par;

/**********************************************
OK
country=US/state=CA
country=US/state=IL
country=US/state=OR
Time taken: 0.075 seconds, Fetched: 3 row(s)
**********************************************/

#### Execute query
SELECT * FROM employees_par;
SELECT * FROM employees_par e WHERE e.country='US' and e.state='CA';
SELECT * FROM employees_par e WHERE e.country='US' and e.state='IL';
SELECT * FROM employees_par e WHERE e.country='US' and e.state='OR';

#### Creating Tables and Loading them in One Query
CREATE TABLE employees_ca
AS 
SELECT name, salary, subordinates, deductions, address 
FROM employees_par
WHERE state = 'CA';

#### Execute query
select * FROM employees_ca;

#### Verify tables
SHOW tables;

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

#################################### Managed table (With Partition) - END ##########################################


#################################### Queries (HQL) - START ##########################################

#### Select simple data type from table
select name, salary from employees_par;
.
#### Select ARRAY data type from table
select name, subordinates from employees_par;
select name, subordinates[0] from employees_par;

#### Select MAP data type from table
select name, deductions from employees_par;
select name, deductions["State Taxes"] from employees_par;

#### Select STRUCT data type from table
select name, address.city from employees_par;

#### Compute column values using Numeric Functions
select upper(name), salary, deductions["Federal Taxes"], round(salary * (1-deductions["Federal Taxes"])) 
from employees_par;

#### Compute data using Aggregate Functions
SET hive.map.aggr=true;
select count(*), avg(salary) from employees_par;

#### Table generating functions (one to many lies)
select explode(subordinates) from employees_par;

#### Usage of Limit clause
select upper(name), salary, deductions["Federal Taxes"], round(salary * (1-deductions["Federal Taxes"])) 
from employees_par LIMIT 3;

#### Usage of Case statement
select name, salary,
case
when salary < 70000 then 'low'
when salary > 70000 and salary <=810000 then 'middle'
when salary > 81000 and salary <=95000 then 'high'
else 'very high' 
end as salary_level
from employees_par;

#### Usage of Where clause with nested selected statement
FROM (
select upper(name) as name, salary, deductions["Federal Taxes"], round(salary * (1-deductions["Federal Taxes"])) as salary_without_ft 
from employees_par
) emp
select emp.name, emp.salary_without_ft 
where emp.salary_without_ft > 20000; 

#### Usage of Where clause with nested selected statement
select emp.name, emp.salary_without_ft 
from 
(
select upper(name) as name, salary, deductions["Federal Taxes"], round(salary * (1-deductions["Federal Taxes"])) as salary_without_ft 
from employees_par
) emp
where emp.salary_without_ft > 70000;

#### Usage of like clause
select name, address.city from employees_par where address.street like '%Ave%';
 
#################################### Queries (HQL) - START ##########################################

