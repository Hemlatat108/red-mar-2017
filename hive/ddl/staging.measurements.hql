1	CREATE EXTERNAL TABLE `staging.measurements`(
2	  `measurement_id` string, 
3	  `detector_id` int, 
4	  `galaxy_id` int, 
5	  `astrophysicist_id` int, 
6	  `measurement_time` double, 
7	  `amplitude_1` float, 
8	  `amplitude_2` float, 
9	  `amplitude_3` float)
10	ROW FORMAT SERDE 
11	  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
12	WITH SERDEPROPERTIES ( 
13	  'field.delim'='^', 
14	  'serialization.format'='^') 
15	STORED AS INPUTFORMAT 
16	  'org.apache.hadoop.mapred.TextInputFormat' 
17	OUTPUTFORMAT 
18	  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
19	LOCATION
20	  'hdfs:///user/admin/staging/measurements'
