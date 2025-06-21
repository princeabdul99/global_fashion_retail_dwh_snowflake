USE WAREHOUSE global_fashion_retail_load_wh;
MERGE INTO silver_db.stg.STORES_TBL_STG tgt
USING (
    SELECT * 
    FROM bronze_db.ext.STORES_STREAM
) stg
ON tgt.storeid = stg.storeid

WHEN MATCHED THEN
    UPDATE SET
        tgt.storeid = stg.storeid,
        tgt.country = stg.country,
        tgt.city = stg.city,
        tgt.storename = stg.storename,
        tgt.numberofemployees = stg.numberofemployees,
        tgt.zipcode = stg.zipcode,
        tgt.latitude = stg.latitude,
        tgt.longitude = stg.longitude,
        tgt.source_file_name = stg.source_file_name,
        tgt.load_ts = stg.load_ts

WHEN NOT MATCHED THEN
    INSERT (storeid, country, city, storename, numberofemployees, zipcode, latitude, longitude, source_file_name, load_ts)
    VALUES (
        stg.storeid,  
        stg.country,  
        stg.city, 
        stg.storename, 
        stg.numberofemployees,  
        stg.zipcode,  
        stg.latitude,  
        stg.longitude,  
        stg.source_file_name,  
        stg.load_ts
    );
