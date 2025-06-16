USE WAREHOUSE global_fashion_retail_load_wh;
MERGE INTO silver_db.stg.TRANSACTIONS_TBL_STG tgt
USING (
    SELECT * 
    FROM bronze_db.ext.TRANSACTIONS_STREAM
) stg
ON tgt.invoiceid = stg.invoiceid

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