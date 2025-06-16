/*
============================================================================================
    Create Roles, Users, Permissions
============================================================================================
Script Purpose:
  This script create project team roles, users and assign role privileges.
 ** Create Roles **
    1. PM - This role can create database and everything inside the database and warehouse
    2. Dev Team - They can do everything inside the database but can not create a new database or warehouse
    3. Analyst Team - They can do read all the data from the table and view but nothing more than that.

  WARNING:
  Running this script should be performed only by the Account Admin. Proceed with caution and ensure you
  have proper permission before running this script.
*/

USE ROLE SECURITYADMIN;

CREATE ROLE "GFR_PM_ROLE" COMMENT = 'This is project manager role for Global Fashion Retails Project';
GRANT ROLE "GFR_PM_ROLE" TO ROLE "SECURITYADMIN";

CREATE ROLE "GFR_DEV_TEAM" COMMENT = 'This is development team for Global Fashion Retails Project';
GRANT ROLE "GFR_DEV_TEAM" TO ROLE "GFR_PM_ROLE";

CREATE ROLE "GFR_ANALYST" COMMENT = 'This is analyst team for Global Fashion Retails Project';
GRANT ROLE "GFR_ANALYST" TO ROLE "GFR_PM_ROLE";


/*
** Example: Create some users
* gfr_pm - the project manager user
* gfr_dev01 - the data enginer user
* gfr_ba_lead - the business analyst lead
* gfr_ba_us - the analyst for United State region
* gfr_ba_cn - the analyst for China region
* gfr_ba_de - the analyst for Germany region
* gfr_ba_gb - the analyst for United Kingdom region
* gfr_ba_fr - the analyst for France region
* gfr_ba_es - the analyst for Spain region
* gfr_ba_pt - the analyst for Portugal region
*/
USE ROLE USERADMIN;

CREATE USER gfr_pm PASSWORD = 'Test@12$4' COMMENT = 'this is a pm user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_dev01 PASSWORD = 'Test@12$4' COMMENT = 'this is a dev-01 user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_lead PASSWORD = 'Test@12$4' COMMENT = 'this is a ba lead user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_us PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-us user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_cn PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-cn user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_de PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-de user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_gb PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-gb user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_fr PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-fr user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_es PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-es user' MUST_CHANGE_PASSWORD = FALSE;
CREATE USER gfr_ba_pt PASSWORD = 'Test@12$4' COMMENT = 'this is a ba-pt user' MUST_CHANGE_PASSWORD = FALSE;


/*
** Manage Role Grant Priviledge to users
*/
USE ROLE SECURITYADMIN;

GRANT ROLE "GFR_PM_ROLE" TO USER gfr_pm;

GRANT ROLE "GFR_DEV_TEAM" TO USER gfr_dev01;

GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_lead;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_us;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_cn;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_de;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_gb;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_fr;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_es;
GRANT ROLE "GFR_ANALYST" TO USER gfr_ba_pt;


/*
** Grant Priviledges to PM Roles (e.g; Database, warehouse creation etc)
*/
USE ROLE SYSADMIN;

GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE "GFR_PM_ROLE";
GRANT CREATE DATABASE ON ACCOUNT TO ROLE "GFR_PM_ROLE";


/*
** Create a Cloud Storage Integration in snowflake
* Note: 
* Only account administrators (users with the ACCOUNTADMIN role) or a role with the 
* global CREATE INTEGRATION privilege can execute this SQL command.
*/
use role ACCOUNTADMIN;

CREATE STORAGE INTEGRATION GFR_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<replace-with-aws-role-arn>'
  STORAGE_ALLOWED_LOCATIONS = ('*');


 -- Retrieve the AWS IAM user for the snowflake account
 DESC INTEGRATION GFR_INTEGRATION;

 /* Granting usage previledge on the storage integration */
 GRANT USAGE ON INTEGRATION GFR_INTEGRATION TO ROLE "GFR_PM_ROLE";
 GRANT USAGE ON INTEGRATION GFR_INTEGRATION TO ROLE "GFR_DEV_TEAM";


