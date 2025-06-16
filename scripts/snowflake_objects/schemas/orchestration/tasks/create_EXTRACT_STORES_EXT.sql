
USE WAREHOUSE global_fashion_retail_load_wh;

/* Loading data from external stage into a staging table */
copy into bronze_db.EXT.STORES_EXT
from (
    select $1, $2, $3, $4, $5, $6, $7, $8, metadata$filename, current_timestamp()
    from @STORES_STAGE
)
on_error = abort_statement;
--on_error = continue;
--purge = true;


--TRUNCATE TABLE STORES_EXT;