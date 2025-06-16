
USE WAREHOUSE global_fashion_retail_load_wh;

/* Loading data from external stage into a staging table */
copy into bronze_db.EXT.TRANSACTIONS_EXT
from (
    select $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, metadata$filename, current_timestamp()
    from @TRANSACTIONS_STAGE
)
on_error = abort_statement;
--on_error = continue;
--purge = true;


--- Unload Staging Table
-- TRUNCATE TABLE TRANSACTIONS_EXT;