
/*
============================================================================================
    Create Data Warehouse 
============================================================================================
Script Purpose:
  This script create a virtual warehouses named 'global_fashion_retail_load_wh' 
  and 'global_fashion_retail_query_wh'after checking if it already exists.
  * global_fashion_retail_load_wh -> used for data ingestion & ETL
  * global_fashion_retail_query_wh -> used by analyst, BI, ad hoc

  WARNING:
  Running this script should be performed only by the PM. Proceed with caution and ensure you
  have proper permission before running this script.
*/

CREATE OR ALTER WAREHOUSE global_fashion_retail_load_wh
    WITH
    WAREHOUSE_SIZE = 'XLARGE'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = true
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    SCALING_POLICY = 'STANDARD';


CREATE OR ALTER WAREHOUSE global_fashion_retail_query_wh
    WITH
    WAREHOUSE_SIZE = 'XSMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = true
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    SCALING_POLICY = 'STANDARD';    

/*
============================================================================================
    Create Databases and Schemas
============================================================================================
Script Purpose:
  This script create a new databases after checking if it already exists.
  * bronze_db -> stores raw external tables
  * silver_db -> stores cleaned/transformed tables - staging tables
  * gold_db -> stores models amd final tables/Views
*/

CREATE DATABASE bronze_db;
CREATE DATABASE silver_db;
CREATE DATABASE gold_db;

/*
  The schema within the database: 
  'bronze' -> EXT, 
  'silver' -> STG, 
  'gold' -> DWH.
*/
USE DATABASE bronze_db;
CREATE SCHEMA EXT;

USE DATABASE silver_db;
CREATE SCHEMA STG;

USE DATABASE gold_db;
CREATE SCHEMA DWH;

-- ========================================
-- Grant usage privileges to DEV TEAM Role
-- ========================================
GRANT USAGE ON WAREHOUSE global_fashion_retail_query_wh TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON WAREHOUSE global_fashion_retail_load_wh TO ROLE "GFR_DEV_TEAM";


GRANT USAGE ON DATABASE bronze_db TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON DATABASE silver_db TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON DATABASE gold_db TO ROLE "GFR_DEV_TEAM";
use database bronze_db; // use database bronze 
GRANT ALL PRIVILEGES ON SCHEMA EXT TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA EXT TO ROLE "GFR_DEV_TEAM";
use database silver_db; // use database silver
GRANT ALL PRIVILEGES ON SCHEMA STG TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA STG TO ROLE "GFR_DEV_TEAM";
use database gold_db; // use database gold
GRANT ALL PRIVILEGES ON SCHEMA DWH TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA DWH TO ROLE "GFR_DEV_TEAM";


-- ============================================
-- Grant usage privileges to ANALSYT TEAM Role
-- ============================================
GRANT USAGE ON WAREHOUSE global_fashion_retail_query_wh TO ROLE "GFR_ANALYST";
GRANT USAGE ON DATABASE gold_db TO ROLE "GFR_ANALYST";
use database gold_db; // 
GRANT ALL PRIVILEGES ON SCHEMA DWH TO ROLE "GFR_ANALYST";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA DWH TO ROLE "GFR_ANALYST";