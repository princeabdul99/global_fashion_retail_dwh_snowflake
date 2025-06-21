
/*
 ========================================================================
 - Create the extract table for transactions in raw (csv) format
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh;
use database bronze_db;
USE SCHEMA EXT;

CREATE OR REPLACE TABLE TRANSACTIONS_EXT (
    invoiceid varchar,
    line number,
    customerid int,
    productid int,
    size varchar,
    color varchar,
    unitprice float,
    quantity number,
    date date,
    discount float,
    linetotal float,
    storeid int,
    employeeid int,
    currency varchar,
    currencysymbol varchar,
    sku varchar,
    transactiontype varchar,
    paymentmethod varchar,
    invoicetotal float,
    source_file_name varchar,
    load_ts timestamp
);
