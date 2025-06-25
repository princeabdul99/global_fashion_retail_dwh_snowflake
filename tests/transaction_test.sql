USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH;

USE DATABASE gfr_load_db;
USE SCHEMA EXT;

-- display the ARN of SQS queue

SHOW PIPES;

--- Ingest files that were already created.
ALTER PIPE GFR_TRANSACTIONS_PIPE REFRESH;

--  Testing: View list of files in the external stage
list @TRANSACTIONS_STAGE;

/* View load history for the TRANSACTIONS_EXT */
select *
from information_schema.load_history
where schema_name = 'EXT' 
and table_name = 'TRANSACTIONS_EXT'
order by last_load_time desc;

/* stage metadata with directory tables */
-- Add directory table to external stage
alter stage TRANSACTIONS_STAGE
set directory = (enable = true);

-- refresh directory table manually
alter stage TRANSACTIONS_STAGE refresh;

-- Testing: View external stage files in directory
select *
from directory (@TRANSACTIONS_STAGE);

-- Monitoring & Troubleshooting pipe objects: check this status of the pipe 
select system$pipe_status('GFR_TRANSACTIONS_PIPE');

--copy_history function: displays loading history for a table resulting from 
-- copy command executed. ex: view the loading history for 'TRANSACTIONS_EXT' table within the last hour (day, month etc)
select *
 from table(information_schema.copy_history(
  table_name => 'TRANSACTIONS_EXT', 
  start_time => dateadd(day, -7, current_timestamp())));


SELECT TOP 100 * FROM gfr_load_db.EXT.TRANSACTIONS_EXT;

TRUNCATE TABLE gfr_load_db.EXT.TRANSACTIONS_EXT;

SELECT * FROM gfr_load_db.EXT.TRANSACTIONS_STREAM;

//================ TESTING TASK HISTORY ============
 select *
  from table(information_schema.task_history())
  order by scheduled_time desc;

SELECT TOP 100
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
    invoiceid,
    line,
    customerid,
    productid,
    CASE WHEN size IS NULL THEN 'n/a' 
            ELSE size
    END AS size,
    CASE WHEN color IS NULL THEN 'n/a' 
            ELSE color
    END AS color,
    unitprice,
    quantity,
    date,
    discount,
    linetotal,
    storeid,
    employeeid,
    currency,
    currencysymbol, 
    CASE WHEN RIGHT(sku, 2) = '--' THEN LEFT(sku, LEN(sku) -2)
         WHEN RIGHT(sku, 1) = '-' THEN LEFT(sku, LEN(sku) -1)
        ELSE sku
    END AS sku,    
    transactiontype,
    paymentmethod,
    invoicetotal,
    source_file_name, 
    load_ts

FROM gfr_load_db.EXT.TRANSACTIONS_EXT
WHERE TRANSACTIONTYPE = 'Return' AND INVOICEID = 'RET-US-001-03856698';



SELECT 
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS generated_id,
    invoiceid
FROM gfr_load_db.EXT.TRANSACTIONS_EXT
LIMIT 100;

WITH test AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
        invoiceid
    FROM gfr_load_db.EXT.TRANSACTIONS_EXT
)
SELECT * FROM test ORDER BY id LIMIT 100;





//================== STAGING LAYER ===========================
USE DATABASE gfr_load_db;
USE SCHEMA STG;
// Querying STORES_STG staging table
select * from gfr_load_db.STG.TRANSACTIONS_TBL_STG;

SELECT TOP 100 * FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG;

TRUNCATE TABLE gfr_load_db.STG.TRANSACTIONS_TBL_STG;

// ============ TRANSACTIONS  ANALYSIS ================
// Task 1: Create separate table for sold items
// Task 2: Create a separate table for return items
SELECT TOP 100 * 
FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
WHERE TRANSACTIONTYPE = 'Sale';

SELECT TOP 100 * 
FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
WHERE TRANSACTIONTYPE = 'Return';

// Task 3: Create a separate sales table for invoice total
// Task 4: Create a separate return table for invoice total
-- ** Challenge: Table should have only invoicetotal per transaction  
    SELECT *
    FROM (
        SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY invoiceid ORDER BY date desc) as flag_last,
        FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
    ) t ;
    //WHERE flag_last = 1 AND t.transactiontype = 'Sale';

    SELECT TOP 100 *
    FROM (
        SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY invoiceid ORDER BY date desc) as flag_last,
        FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
    ) t WHERE flag_last = 1 AND t.transactiontype = 'Return';

    // Task 5: What is the total sale by each country?
    SELECT 
      sum(invoicetotal) as total_amount, currency as country
    FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
    WHERE transactiontype = 'Sale'
    GROUP BY currency;       
    
    
 //================== DWH LAYER ===========================
USE DATABASE GOLD_DB;
USE SCHEMA DWH;

// Business Question: What is the total sale by each country?
SELECT TOP 10
    sum(invoicetotal) as total_amount, 
    currency 
FROM gold_db.DWH.TRANSACTIONS_TBL
GROUP BY currency;