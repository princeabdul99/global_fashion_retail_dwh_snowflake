/*
 ========================================================================
 - Create the staging table in the STG schema that will store data from
 - the  extraction layer. e.g, STORES_EXT
 ========================================================================
 */
 
USE WAREHOUSE global_fashion_retail_load_wh_xsmall;
USE DATABASE gfr_load_db;
USE SCHEMA STG;
CREATE OR ALTER TABLE TRANSACTIONS_TBL_STG (
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
