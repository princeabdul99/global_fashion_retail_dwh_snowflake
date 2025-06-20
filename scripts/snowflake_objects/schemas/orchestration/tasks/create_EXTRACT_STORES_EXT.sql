
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;

USE DATABASE bronze_db;
USE SCHEMA EXT;

/* Loading data from external stage into a staging table */

CREATE PIPE bronze_db.EXT.GFR_PIPE
    AUTO_INGEST = TRUE
    AWS_SNS_TOPIC = 'arn:aws:sns:us-east-1:448049813931:GFR_Notification'
    AS
        COPY INTO bronze_db.EXT.STORES_EXT
        FROM (
            SELECT $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
            FROM @STORES_STAGE
        );
--on_error = abort_statement;
--on_error = continue;
--purge = true;

-- SHOW PIPES;
--TRUNCATE TABLE STORES_EXT;