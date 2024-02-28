# ML Pipelines with Snowflake and dbt
This demo showcases how to use Snowflake and dbt to build scalable machine learning pipelines. It is based on the code from this [dbt-labs guide](https://docs.getdbt.com/guides/dbt-python-snowpark?step=1), which I used as a reference while builing ML pipelines to predict user conversion and subscription churn at [Surfline](https://www.surfline.com).

## Key Learning
From this experience, I've modified my worflow from steps in the dbt-labs. My steps are:
1. Uses SQL to build features over Python. Faster, easier to debug, easier to share with others.
2. Build preprocessing pipelines and ML models in Python notebooks, not dbt Python models. The reasons for this are:
   - Notebooks are better for *developing ML models*, a process that is iterative and mixes code, stats, and data visualiaztion.
   - Uses the `snowflake-snowpark-python` and `snowflake-ml-python` libraries (optimized, parallel, fast) over `pandas` (single-thread, slow) to develop preprocessing pipelines and ML models.
   - Save the preprocessing pipelines to a Snowflake internal stage so it can be called from dbt Python models.
   - Save the ML models to the Snowflake model registry so it can be called from dbt Python models.
3. Use dbt Python to *deploy* our ML models and keep them part of the dbt DAG and allowing for docs, tests, and lineage to be tracked.

## Outline
This demo covers the following steps:
1. Setting up a Snowflake *from scratch* with databases, warehouses, roles, and permissions.
2. Loading example Formula 1 data from a public s3 bucket into a `RAW` database in a `FORMULA1` schema in Snowflake.
3. Using dbt SQL models to:
   - Stage the raw data (renames, data type casting, etc.).
   - Create intermediate tables for feature engineering.
   - Create a data mart with fact and dimension tables.
   - Freate feature tables as input for ML models.
4. Developing ML pipelines and models in Python notebooks to:
   - Preprocessing data.
   - Training and testing ML models.
   - Registering the trained models to a Snowflake stage.
5. Using dbt Python models to:
   - Load the trained ML pipelines and models from the Snowflake stage.
   - Apply the ML pipelines and models to data from our data mart to make predictions.
   - Store the predictions in a new table in the `FORMULA1` database.
