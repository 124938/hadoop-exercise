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

#### Create external table to stage data
create external table if not exists dividends_stage (
exch string,
symbol string,
ymd string,
dividend float
)
row format delimited
fields terminated by ','
location '/user/cloudera/dividends_stage';

#### load data to staging table
load data local inpath '${env:HOME}/hive/dividends.csv'
into table dividends_stage;

#### Execute query
select * from dividends_stage limit 10;

#### Create external with partition
create external table if not exists dividends (
ymd string,
dividend float
)
partitioned by (exch string, symbol string)
row format delimited
fields terminated by ','
location '/user/cloudera/dividends';

##### Enable dynamic partition feature - by default it is not allowed
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions.pernode=500;

#### insert data using partition
INSERT INTO TABLE dividends
PARTITION (exch, symbol)
SELECT ymd, dividend, exch, symbol
FROM dividends_stage;

#################################### External table - END ##########################################

#### Usage of Aggregate functions
SELECT count(DISTINCT symbol) FROM stocks;
SELECT count(DISTINCT ymd), count(DISTINCT volume) FROM stocks;

#### Usage of GROUP BY Clauses
select symbol, year(ymd), avg(price_close)
from stocks
where exch = 'NASDAQ' and symbol = 'AAPL'
group by symbol, year(ymd);

#### Usage of GROUP BY Clauses - With Having Clause
select symbol, year(ymd), avg(price_close)
from stocks
where exch = 'NASDAQ' and symbol = 'AAPL'
group by symbol, year(ymd)
having avg(price_close) > 50;

#### Usage of inner join on same table
select a.ymd, a.symbol, a.price_close, b.symbol, b.price_close
from stocks a join stocks b on (a.ymd = b.ymd)
where a.symbol = 'AAPL' and b.symbol = 'IBM' and year(a.ymd) > 2009;

#### Usage of multiple inner join on same table
select a.ymd, a.symbol, a.price_close, b.symbol, b.price_close, c.symbol, c.price_close
from stocks a join stocks b on (a.ymd = b.ymd) join stocks c on (c.ymd = b.ymd)
where a.symbol = 'AAPL' and b.symbol = 'IBM' and c.symbol = 'GE' and year(a.ymd) > 2009;

#### Usage of inner join on different table
select s.ymd, s.symbol, s.price_close, d.dividend
from stocks s join dividends d on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol)
where s.exch = 'NASDAQ' and s.symbol = 'AAPL';

#### Usage of left outer inner join on different table
select s.ymd, s.symbol, s.price_close, d.dividend
from stocks s left outer join dividends d on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol)
where s.exch = 'NASDAQ' and s.symbol = 'AAPL' and year(s.ymd) > 1990 and year(s.ymd) < 1993;

#### Usage of left outer inner join on different table - effective query
select s.ymd, s.symbol, s.price_close, d.dividend
from 
(select * from stocks where exch = 'NASDAQ' and symbol = 'AAPL') s 
left outer join 
(select * from dividends where exch = 'NASDAQ' and symbol = 'AAPL') d 
on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol)
where year(s.ymd) = 1990;

#### Usage of right outer inner join on different table
select s.ymd, s.symbol, s.price_close, d.dividend
from stocks s right outer join dividends d on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol)
where s.exch = 'NASDAQ' and s.symbol = 'AAPL' and year(s.ymd) = 1990;

#### Usage of full outer inner join on different table
select s.ymd, s.symbol, s.price_close, d.dividend
from stocks s full outer join dividends d on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol)
where s.exch = 'NASDAQ' and s.symbol = 'AAPL' and year(s.ymd) > 1990 and year(s.ymd) < 1993;

#### Usage of left semi join on different table - IN...EXIST clause is not supported in hive
select s.ymd, s.symbol, s.price_close
from stocks s left semi join dividends d on (s.exch = d.exch and s.ymd = d.ymd AND s.symbol = d.symbol);

#### Usage of cross product - Very costly on cluster
SELECT * FROM stocks JOIN dividends
where stocks.symbol = dividends.symbol and stocks.symbol='AAPL';

set hive.mapjoin.smalltable.filesize
