
/*
============================================================================================
    Create Data Warehouse 
============================================================================================
Script Purpose:
  This script create a virtual warehouses named 'global_fashion_retail_load_wh' 
  and 'global_fashion_retail_query_wh'after checking if it already exists.
  * global_fashion_retail_load_wh -> used for data ingestion & ETL
  * global_fashion_retail_query_wh -> used by analyst, BI, ad-hoc

  Note: 
    Different size of warehouse is created inorder to compare perform performance and choose
    the proper warehouse that soothe the project while controlling cost.

  WARNING:
  Running this script should be performed only by the PM. Proceed with caution and ensure you
  have proper permission before running this script.
*/

CREATE OR ALTER WAREHOUSE global_fashion_retail_load_wh_xsmall
    WITH
    WAREHOUSE_SIZE = 'XSMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = true
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    SCALING_POLICY = 'STANDARD';

CREATE OR ALTER WAREHOUSE global_fashion_retail_load_wh_small
    WITH
    WAREHOUSE_SIZE = 'SMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = true
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    SCALING_POLICY = 'STANDARD';  

CREATE OR ALTER WAREHOUSE global_fashion_retail_load_wh_medium
    WITH
    WAREHOUSE_SIZE = 'MEDIUM'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = true
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 1
    SCALING_POLICY = 'STANDARD';

CREATE OR ALTER WAREHOUSE global_fashion_retail_load_wh_large
    WITH
    WAREHOUSE_SIZE = 'LARGE'
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
  * gold_db -> stores models and final tables/Views (dynamic tables)
*/

CREATE DATABASE bronze_db;
CREATE DATABASE silver_db;
CREATE DATABASE gold_db;

/*
  The schema within the database: 
  'bronze' -> EXT,  
  'silver' -> STG, 
  'gold'   -> DWH,
  'gold'   -> RPT.

  EXT represent the extraction layer
  STG represent the staging layer
  DWH represent the data warehouse layer
  RPT represent the presentation layer

*/
USE DATABASE bronze_db;
CREATE SCHEMA EXT;
CREATE SCHEMA EXT_ORCHESTRATION;

USE DATABASE silver_db;
CREATE SCHEMA STG;
CREATE SCHEMA ORCHESTRATION;

USE DATABASE gold_db;
CREATE SCHEMA DWH;
CREATE SCHEMA RPT;