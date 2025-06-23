USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
USE DATABASE silver_db;
USE SCHEMA STG;
USE SCHEMA ORCHESTRATION;

CREATE OR REPLACE TASK MERGE_STORES_STG_TASK
    WAREHOUSE = 'GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL'
    AFTER COPY_STORES_TASKS
WHEN
    system$stream_has_data('bronze_db.ext.STORES_STREAM')
AS
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


// Note: New task created is suspended by default. Resume task to start executing. 
ALTER TASK MERGE_STORES_STG_TASK RESUME;
ALTER TASK COPY_STORES_TASKS RESUME;