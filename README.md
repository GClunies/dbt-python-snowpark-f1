# ML Pipelines with Snowflake and dbt
This demo showcases how to use Snowflake and dbt to build scalable machine learning pipelines. It is based on the code from this [dbt-labs guide](https://docs.getdbt.com/guides/dbt-python-snowpark?step=1), which I used as a reference while builing ML pipelines to predict user conversion and subscription churn at [Surfline](https://www.surfline.com).

Upon reflection, there are improvements to be made on dbt-labs' approach. This demo provides a more efficient and realistic alternative for building ML pipelines with Snowflake and dbt.

## Slides
- dbt & Snowflake (quick AF refresh)
- Tradition ML Pipeline Development
- Data Warehouse --> Data Cloud
- dbt Python
  - when to use
  - when not
- Demo

## Key Learnings

1. Use dbt SQL to build features whenever possible. dbt SQL is easier to read and debug reltive to dbt Python.
2. Use `snowflake-snowpark-python` and `snowflake-ml-python` libraries (optimized, parallel, fast) over `pandas` (single-thread, slow).
3. Build preprocessing pipelines and ML models in Python notebooks over dbt Python. Use Snowpark:
   - Internal stages to store preproccesing pipelines.
   - Model registry to store ML models.
4. dbt Python models are great to *execute ML models*... but not to *develop* them.

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
