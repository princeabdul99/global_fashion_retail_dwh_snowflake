
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;

USE DATABASE bronze_db;
USE SCHEMA EXT;

/* Loading data from external stage into a staging table */
USE SCHEMA EXT_ORCHESTRATION;

USE SCHEMA silver_db.ORCHESTRATION;

CREATE OR REPLACE TASK COPY_STORES_TASKS
    WAREHOUSE = 'GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL'
    SCHEDULE = '10 M'
 AS
    COPY INTO bronze_db.EXT.STORES_EXT
        FROM (
            SELECT $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
            FROM @STORES_STAGE
        )
    ON_ERROR = abort_statement
    PURGE = true;

-- To test a task, we can run it manually with the EXECUTE TASK command
EXECUTE TASK COPY_STORES_TASKS;




/* Using SNS notification event
CREATE PIPE bronze_db.EXT.GFR_STORES_PIPE
    AUTO_INGEST = TRUE
    AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:448049813931:GFR_Notification'
    AS
        COPY INTO bronze_db.EXT.STORES_EXT
        FROM (
            SELECT $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
            FROM @STORES_STAGE
        );
*/

-- SHOW PIPES;
--TRUNCATE TABLE STORES_EXT;