
select current_account(),current_user(), current_role();
desc user gfr_pm;
show grants to user gfr_pm;
show grants to role GFR_DEV_TEAM;

-- Use role gfr_pm_role   // pm role
-- use role gfr_dev_team  // dev team 
use role gfr_dev_team;

show warehouses;
show databases;
show schemas;