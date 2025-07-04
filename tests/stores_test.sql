USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
USE DATABASE gfr_load_db;
USE SCHEMA EXT;


SHOW PIPES;

SHOW INTEGRATIONS;

SHOW STAGES;

-- Testing: View external stage files in directory
select *
from directory (@STORES_STAGE);

-- refresh directory table manually
alter stage STORES_STAGE refresh;

--  Testing: View list of files in the external stage
list @STORES_STAGE;

/* View load history for the STORES_EXT */
select *
from information_schema.load_history
where schema_name = 'EXT' 
and table_name = 'STORES_EXT'
order by last_load_time desc;

-- Monitoring & Troubleshooting pipe objects: check this status of the pipe 
select system$pipe_status('GFR_STORES_PIPE');
--- Ingest files that were already created.
ALTER PIPE GFR_STORES_PIPE REFRESH;


SELECT TOP 100 * FROM STORES_EXT;

SELECT TOP 100 * FROM STORES_STREAM;

SELECT * 
FROM STORES_EXT
WHERE COUNTRY = 'United States';

// Task 1: What is the total number of employees in each country?
// Task 2: What is the total number of stores in each country?
SELECT 
     country,  sum(numberofemployees) as total_employees, count(storename) as total_store
FROM STORES_EXT
GROUP BY country;

// Total number of employee and stores
SELECT 
    sum(numberofemployees) as total_employees, count(storename) as total_store
FROM STORES_EXT;

//================== STAGING LAYER ===========================
USE DATABASE gfr_load_db;
USE SCHEMA STG;
// Querying STORES_STG staging table
select TOP 100 * from gfr_load_db.STG.STORES_TBL_STG;

// Task 1: What is the total number of employees in each country?
// Task 2: What is the total number of stores in each country?
SELECT 
     country,  sum(numberofemployees) as total_employees, count(storename) as total_store
FROM gfr_load_db.STG.STORES_TBL_STG
GROUP BY country;

// Total number of employee and stores
SELECT 
    sum(numberofemployees) as total_employees, count(storename) as total_store
FROM gfr_load_db.STG.STORES_TBL_STG;

//================ TESTING TASK HISTORY ============
 select *
  from table(information_schema.task_history())
  order by scheduled_time desc;  

