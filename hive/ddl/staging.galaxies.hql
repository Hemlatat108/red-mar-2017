1	CREATE EXTERNAL TABLE `staging.galaxies`(
2	  `galaxy_id` int, 
3	  `galaxy_name` string, 
4	  `galaxy_type` string, 
5	  `distance_ly` float, 
6	  `absolute_magnitude` float, 
7	  `apparent_magnitude` float, 
8	  `galaxy_group` string)
9	ROW FORMAT SERDE 
10	  'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
11	WITH SERDEPROPERTIES ( 
12	  'field.delim'='^', 
13	  'serialization.format'='^') 
14	STORED AS INPUTFORMAT 
15	  'org.apache.hadoop.mapred.TextInputFormat' 
16	OUTPUTFORMAT 
17	  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
18	LOCATION
19	  'hdfs:///user/admin/staging/galaxies'
