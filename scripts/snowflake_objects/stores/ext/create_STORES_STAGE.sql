/*
 ========================================================================
 - Create an external stage named STORES_STAGE using the GFR_INTEGRATION
 ========================================================================
 */
USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
 USE DATABASE BRONZE_DB;
 USE SCHEMA EXT;
 /* Create reusable named file format */
CREATE OR REPLACE FILE FORMAT CSV_FORMAT
    type = csv
    field_delimiter = ','
    skip_header = 1;

CREATE OR REPLACE STAGE STORES_STAGE
    STORAGE_INTEGRATION = GFR_INTEGRATION
    URL = 's3://bucket-global-fashion-retail/stores/'
    FILE_FORMAT = CSV_FORMAT;

-- Enabling DIRECTORY table for stage metadata
-- Note: This is useful when you need more detailed information about files
--       that are available in a stage. Instead of the LIST command (LIST @STORES_STAGE)
ALTER STAGE STORES_STAGE
SET DIRECTORY = (enable = true);

ALTER STAGE STORES_STAGE REFRESH;