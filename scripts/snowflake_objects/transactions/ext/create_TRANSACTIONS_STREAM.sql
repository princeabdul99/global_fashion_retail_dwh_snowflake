/*
- INGESTING FILES FROM CLOUD STORAGE INCREMENTALLY
-- create a stream named TRANSACTION_STREAM on top of TRANSACTIONS_EXT table in the extraction layer
-- to detect the newly arrived data.
-- Create a table TRANSACTION_TBL_STG in the staging layer to implement incremental ingestion.
 */

USE DATABASE gfr_load_db;
 USE SCHEMA EXT;
CREATE OR REPLACE STREAM TRANSACTIONS_STREAM
ON TABLE TRANSACTIONS_EXT;