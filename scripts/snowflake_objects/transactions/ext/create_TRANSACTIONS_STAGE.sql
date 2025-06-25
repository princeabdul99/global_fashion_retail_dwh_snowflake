/*
 ===============================================================================
 - Create an external stage named TRANSACTIONS_STAGE using the GFR_INTEGRATION
 ===============================================================================
 */

USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
USE DATABASE gfr_load_db;
 USE SCHEMA EXT;
 /* Create reusable named file format */
 CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    type = csv
    field_delimiter = ','
    skip_header = 1;


CREATE OR REPLACE STAGE TRANSACTIONS_STAGE
    STORAGE_INTEGRATION = GFR_INTEGRATION
    URL = 's3://bucket-global-fashion-retail/transactions/'
    FILE_FORMAT = gfr_load_db.EXT.CSV_FORMAT;

-- Enabling DIRECTORY table for stage metadata
-- Note: This is useful when you need more detailed information about files
--       that are available in a stage. Instead of the LIST command (LIST @TRANSACTIONS_STAGE)
ALTER STAGE TRANSACTIONS_STAGE
SET DIRECTORY = (enable = true);

ALTER STAGE TRANSACTIONS_STAGE REFRESH;    