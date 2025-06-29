
/*
============================================================================================
    USER PRIVILEGES
============================================================================================
Script Purpose:
  This script the grant or assign the access privileges to roles. User that are assign specific
  role have the privilege to use or perform specific action.
  ex: GFR_DEV_TEAM role is given the privilege to create database, schema etc
  ex: GFR_ANALYST role is not given such privilege to create but can and read data.

  WARNING:
  Running this script should be performed only by the PM. Proceed with caution and ensure you
  have proper permission before running this script.
*/

USE ROLE GFR_PM_ROLE;
-- ========================================
-- Grant usage privileges to DEV TEAM Role
-- ========================================
GRANT USAGE ON WAREHOUSE global_fashion_retail_load_wh_xsmall TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON WAREHOUSE global_fashion_retail_load_wh_small TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON WAREHOUSE global_fashion_retail_load_wh_medium TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON WAREHOUSE global_fashion_retail_load_wh_large TO ROLE "GFR_DEV_TEAM";


GRANT USAGE ON DATABASE gfr_load_db TO ROLE "GFR_DEV_TEAM";
GRANT USAGE ON DATABASE gfr_query_db TO ROLE "GFR_DEV_TEAM";

use database gfr_load_db; // use database bronze 
GRANT ALL PRIVILEGES ON SCHEMA EXT TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA EXT TO ROLE "GFR_DEV_TEAM";

GRANT ALL PRIVILEGES ON SCHEMA STG TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA STG TO ROLE "GFR_DEV_TEAM";

GRANT ALL PRIVILEGES ON SCHEMA DWH TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA DWH TO ROLE "GFR_DEV_TEAM";

GRANT ALL PRIVILEGES ON SCHEMA ORCHESTRATION TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ORCHESTRATION TO ROLE "GFR_DEV_TEAM";
--- Git integration RBAC
GRANT ALL PRIVILEGES ON SCHEMA GIT_INTEGRATION TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA GIT_INTEGRATION TO ROLE "GFR_DEV_TEAM";




use database gfr_query_db; // For Presentation Layer
GRANT ALL PRIVILEGES ON SCHEMA RPT TO ROLE "GFR_DEV_TEAM";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA RPT TO ROLE "GFR_DEV_TEAM";


-- ============================================
-- Grant usage privileges to ANALSYT TEAM Role
-- ============================================
GRANT USAGE ON WAREHOUSE global_fashion_retail_query_wh TO ROLE "GFR_ANALYST";
GRANT USAGE ON DATABASE gfr_query_db TO ROLE "GFR_ANALYST";
GRANT USAGE ON DATABASE gfr_load_db TO ROLE "GFR_ANALYST";

use database gfr_query_db;
GRANT ALL PRIVILEGES ON SCHEMA RPT TO ROLE "GFR_ANALYST";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA RPT TO ROLE "GFR_ANALYST";

use database gfr_load_db;
GRANT ALL PRIVILEGES ON SCHEMA DWH TO ROLE "GFR_ANALYST";
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA DWH TO ROLE "GFR_ANALYST";