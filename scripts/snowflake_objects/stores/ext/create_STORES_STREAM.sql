/*
- INGESTING FILES FROM CLOUD STORAGE INCREMENTALLY
-- create a stream named STORES_STREAM on top of STORES_EXT table in the extraction layer
-- to detect the newly arrived data.
-- Create a table STORES_TBL_STG in the staging layer to implement incremental ingestion.
 */

CREATE STREAM STORES_STREAM
ON TABLE STORES_EXT;