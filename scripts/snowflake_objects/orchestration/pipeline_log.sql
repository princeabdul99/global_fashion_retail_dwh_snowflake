USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
USE DATABASE GFR_LOAD_DB;
USE SCHEMA ORCHESTRATION;

CREATE OR REPLACE TABLE GFR_PIPELINES_LOG (
    run_group_id varchar,
    root_task_name varchar,
    task_name varchar,
    log_ts timestamp,
    rows_processed number
);

select * from GFR_PIPELINES_LOG order by log_ts desc