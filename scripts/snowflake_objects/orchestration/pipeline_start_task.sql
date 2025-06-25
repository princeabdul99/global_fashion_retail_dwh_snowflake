USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
USE DATABASE GFR_LOAD_DB;
USE SCHEMA ORCHESTRATION;

CREATE OR REPLACE TASK GFR_PIPELINES_START_TASK
    WAREHOUSE = GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL
    SCHEDULE = '10 M'
AS
   call SYSTEM$SEND_EMAIL(
    'GFR_PIPELINE_EMAIL_INT',
    'abubakarabdullahiofficial1@gmail.com',          
    'Daily pipeline start',
    'The daily pipeline started at ' || current_timestamp || '.'
  );
