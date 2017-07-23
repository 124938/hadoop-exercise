#### Create database
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

#################################### External table - START ##########################################

#### Create External table (LOCATION is mandatory)
CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
exch STRING,
symbol STRING,
ymd STRING,
price_open FLOAT,
price_high FLOAT,
price_low FLOAT,
price_close FLOAT,
volume INT,
price_adj_close FLOAT
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
LOCATION '/user/cloudera/stocks';

### Load data using local file
LOAD DATA LOCAL INPATH '${env:HOME}/hive/stocks.csv'
OVERWRITE INTO TABLE stocks;

### Execute query
select * from stocks where exch='NASDAQ' and symbol='AAPL';

### Describe stocks table
describe formatted stocks;

/*************************************************************************************************
OK
# col_name            	data_type           	comment             
	 	 
exch                	string              	                    
symbol              	string              	                    
ymd                 	string              	                    
price_open          	float               	                    
price_high          	float               	                    
price_low           	float               	                    
price_close         	float               	                    
volume              	int                 	                    
price_adj_close     	float               	                    
	 	 
# Detailed Table Information	 	 
Database:           	mydb                	 
Owner:              	cloudera            	 
CreateTime:         	Sun Jul 16 01:30:02 PDT 2017	 
LastAccessTime:     	UNKNOWN             	 
Protect Mode:       	None                	 
Retention:          	0                   	 
Location:           	hdfs://quickstart.cloudera:8020/user/cloudera/stocks	 
Table Type:         	EXTERNAL_TABLE      	 
Table Parameters:	 	 
	COLUMN_STATS_ACCURATE	false               
	EXTERNAL            	TRUE                
	numFiles            	0                   
	numRows             	-1                  
	rawDataSize         	-1                  
	totalSize           	0                   
	transient_lastDdlTime	1500193802          
	 	 
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
Time taken: 0.117 seconds, Fetched: 41 row(s)
*************************************************************************************************/

#################################### External table - END ##########################################


