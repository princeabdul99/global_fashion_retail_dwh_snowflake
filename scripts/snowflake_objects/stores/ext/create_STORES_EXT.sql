
/*
 ========================================================================
 - Create the extract table for stores in raw (csv) format
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
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
