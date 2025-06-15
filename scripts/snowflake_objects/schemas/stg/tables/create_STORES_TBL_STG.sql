/*
 ========================================================================
 - Create the staging table in the STG schema that will store data from
 - the  extraction layer. e.g, STORES_EXT
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh;
use database silver_db;
USE SCHEMA STG;

CREATE OR REPLACE TABLE STORES_TBL_STG (
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
