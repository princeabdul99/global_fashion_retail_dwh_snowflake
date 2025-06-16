USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH;
USE DATABASE BRONZE_DB;
USE SCHEMA EXT;

-- Testing: View external stage files in directory
select *
from directory (@TRANSACTIONS_STAGE);

--  Testing: View list of files in the external stage
list @TRANSACTIONS_STAGE;

/* View load history for the TRANSACTIONS_EXT */
select *
from information_schema.load_history
where schema_name = 'EXT' 
and table_name = 'TRANSACTIONS_EXT'
order by last_load_time desc;


SELECT * FROM bronze_db.EXT.TRANSACTIONS_EXT;

SELECT * FROM bronze_db.EXT.TRANSACTIONS_STREAM;

//================== STAGING LAYER ===========================
USE DATABASE SILVER_DB;
USE SCHEMA STG;
// Querying STORES_STG staging table
select * from silver_db.STG.TRANSACTIONS_TBL_STG;


TRUNCATE TABLE silver_db.STG.TRANSACTIONS_TBL_STG;