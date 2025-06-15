
/*
 ========================================================================
 - Create the extract table for stores in raw (csv) format
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh;
use database bronze_db;
USE SCHEMA EXT;
CREATE OR REPLACE TABLE STORES_EXT (
    storeid int,
    country varchar,
    city varchar,
    storename varchar,
    numberofemployees number,
    zipcode varchar,
    latitude float,
    longitude float,
    source_file_name varchar,
    load_ts timestamp
);

/* Loading data from external stage into a staging table */
copy into EXT.STORES_EXT
from (
    select $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
    from @STORES_STAGE
)
on_error = abort_statement;
--on_error = continue;
--purge = true;


--TRUNCATE TABLE STORES_EXT;