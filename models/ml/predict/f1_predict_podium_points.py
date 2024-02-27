import os

import joblib
from snowflake.ml.registry import registry
from snowflake.snowpark import functions as F

DATABASE = "FORMULA1"
ML_SCHEMA = "ML"
ML_STAGE = "F1_STAGE"
PIPELINE_FILE = "f1_preprocess_pipeline.joblib"

# Temporary directory to store staged files locally
LOCAL_TEMP_DIR = "/tmp/driver_position"
DOWNLOAD_DIR = os.path.join(LOCAL_TEMP_DIR, "download")
TARGET_MODEL_DIR_PATH = os.path.join(LOCAL_TEMP_DIR, "ml_model")
TARGET_LIB_PATH = os.path.join(LOCAL_TEMP_DIR, "lib")

MODEL_NAME = "F1_XGB_MODEL"
MODEL_VERSION = "V0"

ORIGINAL_FEATURES = [
    "RACE_YEAR",
    "CIRCUIT_NAME",
    "GRID",
    "CONSTRUCTOR_NAME",
    "DRIVER",
    "DRIVERS_AGE_YEARS",
    "DRIVER_CONFIDENCE",
    "CONSTRUCTOR_RELIABILITY",
    "TOTAL_PIT_STOPS_PER_RACE",
]


def model(dbt, session):
    dbt.config(
        packages=["joblib", "snowflake-ml-python", "pyarrow"],
        materialized="table",
    )

    # Read in features
    features_df = dbt.ref("f1_features")[ORIGINAL_FEATURES]

    # Get the preprocessing pipeline
    session.file.get(
        f"@{ML_SCHEMA}.{ML_STAGE}/{PIPELINE_FILE}.gz",
        DOWNLOAD_DIR,
    )
    pipeline_file_path = os.path.join(DOWNLOAD_DIR, f"{PIPELINE_FILE}.gz")
    preprocess_pipeline = joblib.load(pipeline_file_path)

    # Preprocess the features
    processed_df = preprocess_pipeline.fit(features_df).transform(features_df)

    # Keep normalized and encoded features
    data_df = processed_df.drop(ORIGINAL_FEATURES)

    # Define the Model Registry
    native_registry = registry.Registry(
        session=session,
        database_name=DATABASE,
        schema_name=ML_SCHEMA,
    )

    # Get trained model from the registry
    model = native_registry.get_model(MODEL_NAME).version(MODEL_VERSION)

    # Make predictions
    predict_df = model.run(data_df, function_name="predict")
    final_df = predict_df.rename(
        F.col('"output_feature_0"'), "PREDICTED_POSITION_LABEL"
    )

    return final_df
