
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
USE DATABASE gfr_load_db;
USE SCHEMA ORCHESTRATION;

/* Loading data from external stage into a staging table */

CREATE OR REPLACE TASK COPY_TRANSACTIONS_TASKS
    WAREHOUSE = 'GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL'
    -- SCHEDULE = '10 M'
    AFTER GFR_PIPELINES_START_TASK
 AS
    BEGIN
        COPY INTO gfr_load_db.EXT.TRANSACTIONS_EXT
            FROM (
                SELECT $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, metadata$filename, current_timestamp()
                FROM @gfr_load_db.EXT.TRANSACTIONS_STAGE
            )
        ON_ERROR = abort_statement;
    -- PURGE = true;

        INSERT INTO GFR_PIPELINES_LOG
        SELECT
            SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID'),
            SYSTEM$TASK_RUNTIME_INFO('CURRENT_ROOT_TASK_NAME'),
            SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_NAME'),
            CURRENT_TIMESTAMP(),
            :SQLROWCOUNT;
   END;

-- To test a task, we can run it manually with the EXECUTE TASK command
EXECUTE TASK COPY_TRANSACTIONS_TASKS;


show stages;


/*
CREATE PIPE bronze_db.EXT.GFR_TRANSACTIONS_PIPE
    AUTO_INGEST = TRUE
    AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:448049813931:GFR_Notification'
    AS
        copy into bronze_db.EXT.TRANSACTIONS_EXT
        from (
            select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, metadata$filename, current_timestamp()
            from @TRANSACTIONS_STAGE
        );
--on_error = abort_statement;
--on_error = continue;
--purge = true;
*/

--- Unload Staging Table
-- TRUNCATE TABLE TRANSACTIONS_EXT;
