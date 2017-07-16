###############################################################################################
#Namespaces
#   env - Key=Value configured at OS level (Read Only) => System.getenv(String name)
#   system - Key=Value configured at JVM level (Read/Write) => System.getProperty(String key)
#   hiveconf - Key=Value configured at hive level (Read/Write) => hive-site.xml
#   hivevar - Key=Value configured hive session level (Read/Write)
###############################################################################################

### Go to hive shell (Below should override the default hive config directory to different config directory i.e. very useful for testing purpose)
hive --config /usr/lib/hive/conf_dev

### Go to hive shell (Below should override the default hive configuration)
hive --hiveconf hive.log.dir=/tmp/$username/test_hive_log;
hive --hiveconf hive.root.logger=DEBUG,console;

### Go to hive shell (Below should be used to store key=value pair while starting hive session)
hive --hivevar cob_date=09-jul-2017;

### Go to hive shell (with default configuration)
hive

### Execute shell command from hive shell
!clear;
!cat /usr/lib/hive/conf/hive-site.xml;
!cat /usr/lib/hive/conf/.hiverc;
!hadoop fs -ls /user/cloudera;

### Overide hive configuration/variable in current session
set hiveconf:hive.enforce.bucketing=true;
set hivevar:cob_date=09-jul-2017;
set hive.cli.print.current.db=true;

### Print/Display all namespace related information
set;

### Print/Display all namespace related information (including hadoop HDFS & mapreduce information)
set -v;

### Print/Display specific environment variable
set env:HOME;
set env:HIVE_CONF_DIR;
set env:HIVE_HOME;

### Print/Display specific system variable
set system:user.dir;
set system:user.home;
set system:user.name;

### Print/Display specific hiveconf variable
set hiveconf:hive.root.logger;
set hiveconf:hive.metastore.warehouse.dir;
set hiveconf:hive.metastore.uris;
set hiveconf:hive.enforce.bucketing
set hiveconf:hive.execution.engine;

set hiveconf:javax.jdo.option.ConnectionDriverName;
set hiveconf:javax.jdo.option.ConnectionUserName;
set hiveconf:javax.jdo.option.ConnectionPassword;

set hiveconf:fs.defaultFS;
set hiveconf:mapreduce.framework.name;
set hiveconf:yarn.nodemanager.address;

### Override configuration automatically using .hiverc file


### Execute hive commands without entering into hive shell (Non interactive mode)
hive -e 'SHOW DATABASES';
hive -e 'SHOW TABLES';
hive -e 'SELECT * FROM dummy';

### Execute hive commands from file without entering into hive shell (from file)
hive -f sample_script.hql;


