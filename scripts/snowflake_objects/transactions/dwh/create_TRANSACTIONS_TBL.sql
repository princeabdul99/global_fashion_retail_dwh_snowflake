-- create a dynamic table TRANSACTIONS_TBL in the DWH schema that normalizes the data from the STG schema

USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
USE DATABASE gfr_load_db;
USE SCHEMA DWH;
CREATE OR REPLACE DYNAMIC TABLE DWH.TRANSACTIONS_TBL_DWH
    TARGET_LAG = '1 minute'
    WAREHOUSE = GLOBAL_FASHION_RETAIL_QUERY_WH
    AS
     SELECT *
    FROM (
        SELECT 
            t.invoiceid,  
            t.line,
            t.discount,
            t.linetotal,
            t.invoicetotal,
            s.storeid,
            s.country,
            s.city,
            t.employeeid,
            t.currency,
            t.currencysymbol,
            t.transactiontype,
            t.paymentmethod,
            t.sku,
            t.productid, 
            t.size,  
            t.color,
            t.customerid, 
            t.date,
            t.source_file_name,  
            t.load_ts,
            ROW_NUMBER() OVER (PARTITION BY invoiceid ORDER BY (SELECT NULL)) as flag_last
        
        FROM gfr_load_db.STG.TRANSACTIONS_TBL_STG AS t
        LEFT JOIN gfr_load_db.STG.STORES_TBL_STG AS s
    ) t  WHERE flag_last = 1;