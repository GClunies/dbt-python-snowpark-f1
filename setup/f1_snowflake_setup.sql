-- Reference: https://discourse.getdbt.com/t/setting-up-snowflake-the-exact-grant-statements-we-run/439

-- SIGN INTO SNOWFLAKE AS AN ADMIN USER (e.g. ACCOUNTADMIN)
-- Run the following commands to set up the roles and permissions for a typical dbt project.

-- 1. Set up databases
use role sysadmin;
create database raw;
create database formula1;

-- 2. Set up warehouses
create warehouse loading
    warehouse_size = xsmall
    auto_suspend = 600  -- dbt uses 3600 (reduced since this is for testing only)
    auto_resume = true  -- Claire's guide has `auto_resume = false`, but this prevented Segment from loading data via the Warehouse!
    initially_suspended = true;

create warehouse transforming
    warehouse_size = xsmall
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true;

create warehouse reporting
    warehouse_size = xsmall
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true;

-- 3. Set up roles and warehouse permissions
use role securityadmin;

create role loader;
grant all on warehouse loading to role loader;

create role transformer;
grant all on warehouse transforming to role transformer;

create role reporter;
grant all on warehouse reporting to role reporter;

-- 4. Create users, assigning them to their roles
create user stitch_user   -- OR fivetran_user (for other data sources)
    password = '_get_from_1password_'
    default_warehouse = loading
    default_role = loader;

create user greg_clunies
    password = '_get_from_1password_'
    default_warehouse = transforming
    default_role = transformer;

create user dbt_cloud_user
    password = '_get_from_1password_'
    default_warehouse = transforming
    default_role = transformer;

create user hex_user -- or mode_user etc.
    password = '_get_from_1password_'
    default_warehouse = reporting
    default_role = reporter;

create user lightdash_user -- or mode_user etc.
    password = '_get_from_1password_'
    default_warehouse = reporting
    default_role = reporter;

-- then grant roles to each user
grant role loader to user stitch_user;
grant role transformer to user dbt_cloud_user;
grant role transformer to user greg_clunies;
grant role reporter to user hex_user;
grant role reporter to user lightdash_user;

-- 5. Let loader load data
use role sysadmin;
grant all on database raw to role loader;
-- grant usage on database raw to role loader;
-- grant create schema on database raw to role loader;

-- 6. Let transformer transform data
grant usage on database raw to role transformer;
grant usage on future schemas in database raw to role transformer;
grant select on future tables in database raw to role transformer;
grant select on future views in database raw to role transformer;

-- If you already have data loaded in the raw database, make sure also you run the following to update the permissions
grant usage on all schemas in database raw to role transformer;
grant select on all tables in database raw to role transformer;
grant select on all views in database raw to role transformer;

-- transformer also needs to be able to create in the formula1 database:
grant all on database formula1 to role transformer;

-- 7. Let reporter read the transformed data
-- A previous version of this article recommended this be implemented through hooks in dbt, but this way lets you get away with a one-off statement.
grant usage on database formula1 to role reporter;
grant usage on future schemas in database formula1 to role reporter;
grant select on future tables in database formula1 to role reporter;

-- Again, if you already have data in your formula1 database, make sure you run:
grant usage on all schemas in database formula1 to role reporter;
grant select on all tables in database formula1 to role transformer;
grant select on all views in database formula1 to role transformer;
