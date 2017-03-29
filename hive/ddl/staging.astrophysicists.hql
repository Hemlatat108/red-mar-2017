CREATE EXTERNAL TABLE `staging.astrophysicists`
  (
    `astrophysicist_id` int,
    `astrophysicist_name` string,
    `year_of_birth` string,
    `nationality` string
  )
	ROW FORMAT SERDE 
    'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
	WITH SERDEPROPERTIES 
    ( 
      'field.delim'='^',
      'serialization.format'='^'
    ) 
	STORED AS INPUTFORMAT 
    'org.apache.hadoop.mapred.TextInputFormat' 
	OUTPUTFORMAT 
    'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
	LOCATION	
    'hdfs:///user/admin/staging/astrophysicists'
