/*
 ========================================================================
 - Create the staging table in the STG schema that will store data from
 - the  extraction layer. e.g, STORES_EXT
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;

CREATE OR REPLACE TABLE silver_db.STG.STORES_TBL_STG (
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
