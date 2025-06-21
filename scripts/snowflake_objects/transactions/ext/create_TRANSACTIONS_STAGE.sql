/*
 ===============================================================================
 - Create an external stage named TRANSACTIONS_STAGE using the GFR_INTEGRATION
 ===============================================================================
 */

 USE DATABASE BRONZE_DB;
 USE SCHEMA EXT;
 /* Create reusable named file format */
 create file format CSV_FORMAT
    type = csv
    field_delimiter = ','
    skip_header = 1;


CREATE OR REPLACE STAGE TRANSACTIONS_STAGE
    STORAGE_INTEGRATION = GFR_INTEGRATION
    URL = 's3://bucket-global-fashion-retail/transactions/'
    FILE_FORMAT = CSV_FORMAT;

-- Enabling DIRECTORY table for stage metadata
-- Note: This is useful when you need more detailed information about files
--       that are available in a stage. Instead of the LIST command (LIST @TRANSACTIONS_STAGE)
ALTER STAGE TRANSACTIONS_STAGE
SET DIRECTORY = (enable = true);

ALTER STAGE TRANSACTIONS_STAGE REFRESH;    