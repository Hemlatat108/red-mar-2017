insert overwrite table ${presentationdatabase}.${tablename} select * from ${stagingdatabase}.${tablename};
