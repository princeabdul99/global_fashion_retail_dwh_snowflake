==============================================================
          Designing the stores orchestration tasks                       
==============================================================

Step Number : 1
Description : New store csv files arrives in the object storage location. (AWS S3 bucket)
Consideration for orchestration : This happens externally and we have no control over it in the data pipeline.

Step Number : 2 (deprecated)
Description : Event trigger is used to notify pipeline when data arrive storage location. The event execute the 
              COPY INTO command to copy content of the newly arrived files into STORES_EXT table in the extraction layer  
Consideration for orchestration : The notification system detects and track changes automatically, so we don't have to do
                                  anything specific in the data pipeline.  

Step Number : 2
Description : The COPY INTO command is executed to copy content of the newly arrived files into STORES_EXT table in the extraction layer  
Consideration for orchestration : This step must be automated with a task.                                 

Step Number : 3
Description : The stream named STORES_STREAM keeps track of new data on STORES_EXT table
Consideration for orchestration : The stream detects and tracks changes automatically, so we don't have to do
                                  anything specific in the data pipeline.                              

Step Number : 4
Description : Insert data from the stream into the STORES_TBL_STG staging table
Consideration for orchestration : This step must be automated with a task.

Step Number : 5
Description : The stores data from the staging layer is propagated to the STORES_TBL_DWH dynamic table in the data warehouse
               layer, where the data is normalized. 
Consideration for orchestration : The dynamic table automatically updates the latest changes according to the specified schedule. 
                                  we don't have to do anything specific in the data pipeline. 

Step Number : 6
Description : The stores data from the data warehouse layer is summarized into the reporting layer in STORES_SUMMARY_TBL dynamic table.
Consideration for orchestration : The dynamic table automatically updates the latest changes according to the specified schedule. 
                                  we don't have to do anything specific in the data pipeline. 


Step Number : 7
Description : <add-text-here>
Consideration for orchestration : <add-text-here>


Step Number : 8
Description : <add-text-here>
Consideration for orchestration : <add-text-here>

Step Number : 9
Description : <add-text-here>
Consideration for orchestration : <add-text-here>


Step Number : 10
Description : <add-text-here>
Consideration for orchestration : <add-text-here>


//**
Step Number : <add-step-number-here>
Description : <add-text-here>
Consideration for orchestration : <add-text-here>
*//
