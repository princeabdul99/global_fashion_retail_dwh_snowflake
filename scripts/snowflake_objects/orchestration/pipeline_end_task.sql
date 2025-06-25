USE WAREHOUSE GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL;
USE DATABASE GFR_LOAD_DB;
USE SCHEMA ORCHESTRATION;

CREATE OR REPLACE TASK GFR_PIPELINES_END_TASK
    WAREHOUSE = GLOBAL_FASHION_RETAIL_LOAD_WH_XSMALL
    FINALIZE = GFR_PIPELINES_START_TASK
AS
    DECLARE
        return_message varchar := '';
    BEGIN 
        let log_cur cursor for
            select task_name, rows_processed
            from GFR_PIPELINES_LOG
            where run_group_id = SYSTEM$TASK_RUNTIME_INFO('CURRENT_TASK_GRAPH_RUN_GROUP_ID');

        for log_rec in log_cur loop
            return_message := return_message ||
            'Task: '|| log_rec.task_name ||
            ' Rows processed: ' || log_rec.rows_processed || '\n';
        end loop;        

        call SYSTEM$SEND_EMAIL(
            'GFR_PIPELINE_EMAIL_INT',
            'abubakarabdullahiofficial1@gmail.com',          
            'Daily pipeline end',
            'The daily pipeline finished at ' || current_timestamp || '.' ||
             '\n\n' || :return_message
        );
    END;

