USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;

USE DATABASE gfr_load_db;
USE SCHEMA EXT;

-- display the ARN of SQS queue

SHOW PIPES;

show streams;

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

  /*
  
  Uncaught exception of type 'STATEMENT_ERROR' on line 2 at position 8 : Duplicate row detected during DML action
Row Values: ["RET-US-001-03856417", 1, 8399, 12917, "G", "PINK", 27.5, 1, 20120, 0, -27.5, 1, 12, "USD", "$", "CHBA12917-G-PINK", "Return", "Credit Card", -118, "transactions/transactions_2025-02.csv", 1750806317588000000]
  
   */


SELECT TOP 100 * FROM gfr_load_db.EXT.TRANSACTIONS_EXT WHERE TRANSACTIONTYPE = 'Return' AND INVOICEID = 'RET-US-001-03856417';

SELECT  TOP 100 * FROM gfr_load_db.EXT.TRANSACTIONS_STREAM;

// TRUNCATE EXT TABLE
TRUNCATE TABLE gfr_load_db.EXT.TRANSACTIONS_EXT;

//================ TESTING TASK HISTORY ============
 select *
  from table(information_schema.task_history())
  order by scheduled_time desc;

//==================================================
SELECT TOP 100
    -- ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
    ROW_NUMBER() OVER (PARTITION BY invoiceid, productid ORDER BY DATE DESC) as flag_last,
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
WHERE TRANSACTIONTYPE = 'Sale' ;
//AND INVOICEID = 'RET-US-001-03856417';

 MERGE INTO gfr_load_db.stg.TRANSACTIONS_TBL_STG tgt
        USING (
            WITH deduplicated AS (
                 SELECT 
                -- ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,
                ROW_NUMBER() OVER (PARTITION BY invoiceid, productid ORDER BY DATE DESC) as flag_last,
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
            FROM gfr_load_db.ext.TRANSACTIONS_STREAM
            )
            
            SELECT * FROM DEDUPLICATED WHERE flag_last = 1
           
        ) stg 
        -- ON tgt.invoiceid = stg.invoiceid
        ON tgt.invoiceid = stg.invoiceid AND tgt.line = stg.line AND tgt.productid = stg.productid

        WHEN MATCHED THEN
            UPDATE SET
                tgt.invoiceid = stg.invoiceid,
                tgt.line = stg.line,
                tgt.customerid = stg.customerid,
                tgt.productid = stg.productid,
                tgt.size = stg.size,
                tgt.color = stg.color,
                tgt.unitprice = stg.unitprice,
                tgt.quantity = stg.quantity,
                tgt.date = stg.date,
                tgt.discount = stg.discount,
                tgt.linetotal = stg.linetotal,
                tgt.storeid = stg.storeid,
                tgt.employeeid = stg.employeeid,
                tgt.currency = stg.currency,
                tgt.currencysymbol = stg.currencysymbol,
                tgt.sku = stg.sku,
                tgt.transactiontype = stg.transactiontype,
                tgt.paymentmethod = stg.paymentmethod,
                tgt.invoicetotal = stg.invoicetotal,
                tgt.source_file_name = stg.source_file_name,
                tgt.load_ts = stg.load_ts

        WHEN NOT MATCHED THEN
            INSERT (
                invoiceid, line, customerid, productid, size, color, unitprice, quantity, date, discount, linetotal, 
                storeid, employeeid, currency, currencysymbol, sku, transactiontype, paymentmethod, invoicetotal, source_file_name, load_ts)
            VALUES (
                stg.invoiceid,  
                stg.line,  
                stg.customerid, 
                stg.productid, 
                stg.size,  
                stg.color,  
                stg.unitprice,  
                stg.quantity,
                stg.date,
                stg.discount,
                stg.linetotal,
                stg.storeid,
                stg.employeeid,
                stg.currency,
                stg.currencysymbol,
                stg.sku,
                stg.transactiontype,
                stg.paymentmethod,
                stg.invoicetotal,
                stg.source_file_name,  
                stg.load_ts
            );

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
select * from gfr_load_db.STG.TRANSACTIONS_TBL_STG ORDER BY DATE ASC;

SELECT TOP 100 * FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG
WHERE DATE = '2025-03-01';

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
USE DATABASE gfr_load_db;
USE SCHEMA DWH;

// Business Question: What is the total sale by each country?
SELECT TOP 10
    sum(invoicetotal) as total_amount, 
    currency 
FROM gfr_load_db.DWH.TRANSACTIONS_TBL
GROUP BY currency;

//================ TESTING TASK HISTORY ============
 select *
  from table(information_schema.task_history())
  order by scheduled_time desc;

//================ TESTING EMAIL NOTIFICATION (email addr of your snowflake user)============
 call SYSTEM$SEND_EMAIL(
    'GFR_PIPELINE_EMAIL_INT',
    'abubakarabdullahiofficial1@gmail.com',          
    'The subject of the email from Snowflake',
    'This is the body of the email.'
 )