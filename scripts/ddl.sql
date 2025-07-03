
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

USE ROLE GFR_PM_ROLE;

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

/*
============================================================================================
    Create Databases and Schemas
============================================================================================
Script Purpose:
  This script create a new databases after checking if it already exists.
  * gfr_load_db -> stores raw external tables
  * gfr_load_db -> stores cleaned/transformed tables - staging tables
  * gfr_query_db -> stores models and final tables/Views (dynamic tables)

  * gfr_load_db -> extraction layer, staging layer, data warehouse layer
  * gfr_query_db -> presentation layer. 
*/

USE ROLE GFR_PM_ROLE;

CREATE OR ALTER DATABASE gfr_load_db;
CREATE OR ALTER DATABASE gfr_query_db;


/*
  The schema within the database: 
  'gfr_load_db' -> EXT,  
  'gfr_load_db' -> STG, 
  'gfr_load_db'   -> DWH,
  'gfr_query_db'   -> RPT.

  EXT represent the extraction layer
  STG represent the staging layer
  DWH represent the data warehouse layer
  RPT represent the presentation layer

*/


USE DATABASE gfr_query_db;
CREATE OR REPLACE SCHEMA RPT;



USE DATABASE gfr_load_db;
CREATE OR REPLACE SCHEMA EXT;
CREATE OR REPLACE SCHEMA STG;
CREATE OR REPLACE SCHEMA DWH;
CREATE OR REPLACE SCHEMA ORCHESTRATION;
CREATE OR REPLACE SCHEMA GIT_INTEGRATION; 
CREATE OR REPLACE SCHEMA EXCHANGERATE;

CREATE OR REPLACE SECRET GFR_SECRET_GIT
  type = password
  username = '<your-git-username>'
  password = '<your-git-password>'

/*
** Create Git Repository Stage
* This exposes the files in the repository to snowflake
*/
CREATE OR REPLACE GIT REPOSITORY GFR_DWH_PROJECT
  API_INTEGRATION = GFR_API_INTEGRATION_GIT
  GIT_CREDENTIALS = GFR_SECRET_GIT
  -- replace the URL to your repository in the next line
  ORIGIN = 'https://<your-git-host>/<your-git-account>/GFR_DWH_SF.git';
  