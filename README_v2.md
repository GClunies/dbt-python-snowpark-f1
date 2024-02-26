# ML Pipelines with Snowflake and dbt
This demo showcases how to use Snowflake and dbt to build scalable machine learning pipelines. Much of the code is based on [dbt-labs' ML guide](https://docs.getdbt.com/guides/dbt-python-snowpark?step=1), with some modifications to improve performance and maintainability.

1. Use dbt SQL models for data mart creation and feature engineering. dbt Python models are much harder to read and debug than dbt SQL models.
2. Use Snowpark optimized DataFrames and libraries (FAST) over `to_pandas()` approach (SLOW).
3. Prototype ML pipelines and models in Python notebooks, migrating to dbt Python when required. Try and reduce code duplication (DRY).
4. Use Snowpark's model registry. Much cleaner than manually managing model versions in a Snowflake stage and calling via UDF.
5. dbt Python models are great to *execute ML models*... but not to *develop* them.

## Setup
1. Create a new Snowflake account (you'll need ACCOUNTADMIN access). [Trial accounts](https://www.snowflake.com/free-trial/) are free for 30 days.
   - Already have a Snowflake account? Use it instead - be sure to review `setup/f1_snowflake_setup.sql` in step `3.` before running.
2. Login to Snowflake. Under `Admin > Billing & Terms`, click `Enable > Acknowledge & Continue` to enable Anaconda Python Packages to run in Snowflake.
3. Open a new SQL worksheet, copy the script from `setup/f1_snowflake_setup.sql` into the worksheet. Select all the code in the worksheet and run it.
4. Open a new SQL worksheet, copy the script from `setup/f1_snowflake_load_data.sql.sql` into the worksheet. Select all the code in the worksheet and run it.

## Outline
This demo covers the following steps:
1. Setting up a Snowflake *from scratch* with databases, warehouses, roles, and permissions.
2. Loading example Formula 1 data from a public s3 bucket into a `RAW` database in a `FORMULA1` schema in Snowflake.
3. Using dbt SQL models to:
   - Stage the raw data (renames, data type casting, etc.).
   - Create intermediate tables for feature engineering.
   - Create a data mart with fact and dimension tables.
4. Developing ML pipelines and models in Python notebooks to:
   - Preprocessing data.
   - Training and testing ML models.
   - Registering the trained models to a Snowflake stage.
5. Using dbt Python models to:
   - Load the trained ML pipelines and models from the Snowflake stage.
   - Apply the ML pipelines and models to data from our data mart to make predictions.
   - Store the predictions in a new table in the `FORMULA1` database.
