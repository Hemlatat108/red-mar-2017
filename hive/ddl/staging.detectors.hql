1	CREATE EXTERNAL TABLE `staging.detectors`(
2	  `detector_id` int, 
3	  `detector_name` string, 
4	  `country` string, 
5	  `latitude` decimal(10,0), 
6	  `longitude` decimal(10,0))
7	ROW FORMAT SERDE 
8	  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
9	WITH SERDEPROPERTIES ( 
10	  'field.delim'='^', 
11	  'serialization.format'='^') 
12	STORED AS INPUTFORMAT 
13	  'org.apache.hadoop.mapred.TextInputFormat' 
14	OUTPUTFORMAT 
15	  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
16	LOCATION
17	  'hdfs:///user/admin/staging/detectors'
