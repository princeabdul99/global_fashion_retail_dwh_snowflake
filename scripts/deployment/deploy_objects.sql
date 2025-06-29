USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
use database GFR_LOAD_DB;


-- ==== STORES ==== 
--- EXT SCHEMA
execute immediate from '../../snowflake_objects/stores/ext/create_STORES_STAGE.sql';
execute immediate from '../../snowflake_objects/stores/ext/create_STORES_EXT.sql';
execute immediate from '../../snowflake_objects/stores/ext/create_STORES_STREAM.sql';

--- STG SCHEMA
execute immediate from '../../snowflake_objects/stores/stg/create_STORES_TBL_STG.sql';

--- DWH SCHEMA

-- ==== TRANSACTIONS ==== 
--- EXT SCHEMA
execute immediate from '../../snowflake_objects/transactions/ext/create_TRANSACTIONS_STAGE.sql';
execute immediate from '../../snowflake_objects/transactions/ext/create_TRANSACTIONS_EXT.sql';
execute immediate from '../../snowflake_objects/transactions/ext/create_TRANSACTIONS_STREAM.sql';

--- STG SCHEMA
execute immediate from '../../snowflake_objects/transactions/stg/create_TRANSACTIONS_TBL_STG.sql';

--- DWH SCHEMA
execute immediate from '../../snowflake_objects/transactions/dwh/create_TRANSACTIONS_TBL.sql';

--- RPT SCHEMA

--- ========= ORCHESTRATION TASKS =============
execute immediate from '../../snowflake_objects/orchestration/pipeline_start_task.sql';
-- stores
execute immediate from '../../snowflake_objects/orchestration/stores/create_EXTRACT_STORES_EXT.sql';
execute immediate from '../../snowflake_objects/orchestration/stores/create_INSERT_STORES_STG_TASK.sql';

-- transactions
execute immediate from '../../snowflake_objects/orchestration/transactions/create_EXTRACT_TRANSACTIONS_EXT.sql';
execute immediate from '../../snowflake_objects/orchestration/transactions/create_INSERT_TRANSACTIONS_STG_TASK.sql';
execute immediate from '../../snowflake_objects/orchestration/pipeline_end_task.sql'


-- snow sql -q "ALTER GIT REPOSITORY GFR_LOAD_DB.GIT_INTEGRATION.GFR_DWH_PROJECT FETCH"
-- snow sql -q "EXECUTE IMMEDIATELY FROM @GFR_LOAD_DB.GIT_INTEGRATION.GFR_DWH_PROJECT/branches/main/global_fashion_retail_dwh_snowflake/scripts/deployment/deploy_objects.sql"
