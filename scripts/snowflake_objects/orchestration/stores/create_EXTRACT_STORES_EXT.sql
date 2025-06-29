
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;

USE DATABASE gfr_load_db;

/* Loading data from external stage into a staging table */
USE SCHEMA ORCHESTRATION;

CREATE OR REPLACE TASK COPY_STORES_TASKS
    WAREHOUSE = 'GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL'
    SCHEDULE = '10 M'
    -- AFTER GFR_PIPELINES_START_TASK
 AS
    BEGIN
        COPY INTO gfr_load_db.EXT.STORES_EXT
            FROM (
                SELECT $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
                FROM @gfr_load_db.EXT.STORES_STAGE
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
EXECUTE TASK COPY_STORES_TASKS;

select * from GFR_PIPELINES_LOG;


/* Using SNS notification event
CREATE PIPE gfr_load_db.EXT.GFR_STORES_PIPE
    AUTO_INGEST = TRUE
    AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:448049813931:GFR_Notification'
    AS
        COPY INTO gfr_load_db.EXT.STORES_EXT
        FROM (
            SELECT $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
            FROM @STORES_STAGE
        );
*/

-- SHOW PIPES;
--TRUNCATE TABLE STORES_EXT;