1	CREATE EXTERNAL TABLE `staging.astrophysicists`(
2	  `astrophysicist_id` int, 
3	  `astrophysicist_name` string, 
4	  `year_of_birth` string, 
5	  `nationality` string)
6	ROW FORMAT SERDE 
7	  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
8	WITH SERDEPROPERTIES ( 
9	  'field.delim'='^', 
10	  'serialization.format'='^') 
11	STORED AS INPUTFORMAT 
12	  'org.apache.hadoop.mapred.TextInputFormat' 
13	OUTPUTFORMAT 
14	  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
15	LOCATION
16	  'hdfs:///user/admin/staging/astrophysicists'
