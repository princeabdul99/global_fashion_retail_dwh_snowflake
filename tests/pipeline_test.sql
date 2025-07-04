USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
USE DATABASE GFR_LOAD_DB;
USE SCHEMA ORCHESTRATION;



-- To test a task, we can run it manually with the EXECUTE TASK command
EXECUTE TASK GFR_PIPELINES_START_TASK;
-- suspend tasks  
ALTER TASK GFR_PIPELINES_START_TASK SUSPEND;
ALTER TASK COPY_STORES_TASKS SUSPEND;
ALTER TASK COPY_TRANSACTIONS_TASKS SUSPEND;
-- unset schedule taks
ALTER TASK COPY_STORES_TASKS UNSET SCHEDULE;
ALTER TASK COPY_TRANSACTIONS_TASKS UNSET SCHEDULE;
-- run tasks
ALTER TASK GFR_PIPELINES_END_TASK RESUME;
ALTER TASK MERGE_STORES_STG_TASK RESUME;
ALTER TASK MERGE_TRANSACTION_STG_TASK RESUME;
ALTER TASK COPY_STORES_TASKS RESUME;
ALTER TASK COPY_TRANSACTIONS_TASKS RESUME;
ALTER TASK GFR_PIPELINES_START_TASK RESUME;

ALTER TASK COPY_STORES_TASKS
    ADD AFTER GFR_PIPELINES_START_TASK;

ALTER TASK COPY_TRANSACTIONS_TASKS
    ADD AFTER GFR_PIPELINES_START_TASK;    


//================ TESTING TASK HISTORY ============
 select *
  from table(information_schema.task_history())
  order by scheduled_time desc;