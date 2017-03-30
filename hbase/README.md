## HBase table to store incoming measurements

Run the HBase shell:
```
> hbase shell
```
Create the table measurements with one column family named 'M':
```
hbase(main):001:0> create  'measurements', {'NAME' => 'M'}
0 row(s) in 2.5130 seconds

=> Hbase::Table - measurements
```
describe the table:
```
hbase(main):002:0> describe 'measurements'
Table measurements is ENABLED                                                                                                                                                                                                           
measurements                                                                                                                                                                                                                            
COLUMN FAMILIES DESCRIPTION                                                                                                                                                                                                             
{NAME => 'M', DATA_BLOCK_ENCODING => 'NONE', BLOOMFILTER => 'ROW', REPLICATION_SCOPE => '0', VERSIONS => '1', COMPRESSION => 'NONE', MIN_VERSIONS => '0', TTL => 'FOREVER', KEEP_DELETED_CELLS => 'FALSE', BLOCKSIZE => '65536', IN_MEMO
RY => 'false', BLOCKCACHE => 'true'}                                                                                                                                                                                                    
1 row(s) in 0.1150 seconds
```
