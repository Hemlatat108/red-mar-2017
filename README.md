# blue-march-2017

## Data Import - Sqoop
Created sqoop jobs to import data from an Oracel database.  There are 4 tables to import:

1. ADMIN.MEASUREMENTS
1. ADMIN.ASTROPHYSICISTS
1. ADMIN.DETECTORS
1. ADMIN.GALAXIES

The measurements table is by far the largest table with 500 million records.  Other tables were small.  

#### Process
Data was imported as text using the ```--direct``` parameter.  Database permissions needed to be modified to use this parameter(catalog read permissions).  Using comma as a delimiter was not successful as there were nested commas in some of the values.  Time was spent attempting to import data directly to [Avro](http://avro.apache.org/) or [Parquet](http://parquet.apache.org/) but sqoop was not able to write in the proper data types directly even when specifying the ```--map-column-hive``` parameter.  We also attempted to create a hive table with the correct schema and use a ```--hive-import```.  

Ultimately the simplest solution was to write the data to a staging database and then provide a set of scripts that would transform the data into a presentation database.  While this is an extra read/write cycle of the data it provides finer control over data types, partitioning, and format.  It also gives an opportunity to add calculated columns.  

#### Solution
Our solution writes all tables as text to tables with the "correct" types defined.  Presentation database tables were created by doing ```create table foo like bar stored as parquet```.  A sample job to load the text data looks like this:

```
import --connect jdbc:oracle:thin:@bootcamp-march2017.cghfmcr8k3ia.us-west-2.rds.amazonaws.com:15210:gravity --username gravity -password *****  --table ${oracletable}  --target-dir /user/admin/staging/${stagingdir} --fields-terminated-by ^ --direct -m ${mappers} -z
```

Once data was written to the staging table there is a simple script ```insert overwrite table presentation.foo select * from staging.foo```.  This was done to leverage hive locking so that any readers of the presentation database will not be interrupted.


## Import Automation - Oozie
Oozie was used to automate and schedule the import of the data.  Since all sqoop jobs were very similar we created a single workflow that contains a paremeterized job that runs a sqoop command and then a hive script to load the presentation table.  There is another workflow that creates views and aggregations.

Troubleshooting time was spent mainly on parameter passing.  We had a good idea of what the workflows should look like at the beginning.

### Workflows
1. ImportTables
    1. Sqoop job to copy data to staging directory
    1. Hive script to insert overwrite table in presentation directory.
1. Materialize - transforms data and prepares it for use.
1. AnomoliesImport - Parent job that calls 4 instances of ImportTables in parallel and then calls the Materialize workflow.

### Corrdinator
There is a single coordinator that runs the AnomoliesImport workflow twice per day.


## Spark

### Sqoop Replacement
Spark can use [JDBC](https://spark.apache.org/docs/1.6.0/sql-programming-guide.html#jdbc-to-other-databases) to retrieve data in a similar fasion to sqoop.  The advantage of this would be that if other spark jobs exists the number of tools used can be reduced.  This works very well for small tables, but was challenging for the largest table.  An index was added to the larger table, but it did not perform nearly as well as the sqoop with ```--direct``` enabled.  The other advantage of spark jdbc was that types are much easier to maintain that with sqoop.

See [SparkJDBCImport.scala](spark/src/main/scala/bootcamp/SparkJDBCImport.scala) for the example code of moving data over to parquet files.

### Analyzing Data
Using the parquet data files written by the jdbc import can be analyzed using the spark dataframe api.  Below are some examples of how to read data, writing any of the intermediate results out can be done in much the same way as the original save.  The only caveat of working with parquet from spark dataframes and interacting with hive is described [here](https://www.cloudera.com/documentation/enterprise/release-notes/topics/cdh_rn_spark_ki.html) "Tables saved with the Spark SQL DataFrame.saveAsTable method are not compatible with Hive"

```
val measurements = sqlContext.read.parquet("/user/ec2-user/sparkimport/ADMIN.MEASUREMENTS")
val detectors = sqlContext.read.parquet("/user/ec2-user/sparkimport/ADMIN.DETECTORS")
val astrophysicists = sqlContext.read.parquet("/user/ec2-user/sparkimport/ADMIN.ASTROPHYSICISTS")

// Count anomolies
measurements.filter("AMPLITUDE_1 > 0.995 AND AMPLITUDE_3 > 0.995 AND AMPLITUDE_2 < 0.005").count
res2: Long = 55  

// Anomolies by detector
measurements.filter("AMPLITUDE_1 > 0.995 AND AMPLITUDE_3 > 0.995 AND AMPLITUDE_2 < 0.005")
  .join(detectors, measurements("detector_id") === detectors("detector_id"))
  .join(astrophysicists, measurements("astrophysicist_id") === astrophysicists("astrophysicist_id"))
  .groupBy(detectors("detector_name"), astrophysicists("astrophysicist_name"))
  .count
  .orderBy(desc("count"))
  .show(100, false)
+----------------+------------------------+-----+                               
|detector_name   |astrophysicist_name     |count|
+----------------+------------------------+-----+
|MiniGRAIL       |Sir Roger Penrose       |2    |
|MiniGRAIL       |Hannes Alven            |1    |
|MiniGRAIL       |George Gamow            |1    |
|LIGO Hanford    |Cecelia Payne-Gaposchkin|1    |
|AURIGA          |Fritz Zwicky            |1    |
|LIGO Hanford    |Edmond Halley           |1    |
|TAMA 300        |Edwin Hubble            |1    |
...
```

## General Issues
#### HUE 400 error message
Navigating to the hue web gui return an 400 error message.
Add the following in Hue safety Valve in CM
```
[desktop]
allowed_hosts=*
```
Restart HUE in CM
