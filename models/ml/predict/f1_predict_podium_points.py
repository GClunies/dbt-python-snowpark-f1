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

MODEL_NAME = "F1_XGB_MODEL"
MODEL_VERSION = "V2"

INDEX = ["RESULT_ID"]  # For joins later
FEATURES = [
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
TARGET = ["POSITION_LABEL"]  # 1 = podium, 2 = points, 3 = no points


def model(dbt, session):
    dbt.config(
        materialized="table",
        packages=[
            "joblib",
            "snowflake-ml-python",
            "pyarrow",  # Required by snowflake-ml-python (but not installed by default)
        ],
    )

    # Read in features
    features_df = dbt.ref("f1_features")[INDEX + FEATURES]

    # Get the preprocessing pipeline
    session.file.get(
        f"@{ML_SCHEMA}.{ML_STAGE}/{PIPELINE_FILE}.gz",
        DOWNLOAD_DIR,
    )
    pipeline_file_path = os.path.join(DOWNLOAD_DIR, f"{PIPELINE_FILE}.gz")
    preprocess_pipeline = joblib.load(pipeline_file_path)

    # Preprocess the features
    preprocess_df = preprocess_pipeline.fit(features_df).transform(features_df)

    # Only keep index, normalized features, and one hot encoded features
    input_df = preprocess_df.drop(FEATURES)

    # Define the Model Registry
    native_registry = registry.Registry(
        session=session,
        database_name=DATABASE,
        schema_name=ML_SCHEMA,
    )

    # Get trained model from the registry
    model = native_registry.get_model(MODEL_NAME).version(MODEL_VERSION)

    # Make predictions
    predict_df = model.run(input_df, function_name="predict")
    predict_df = predict_df.rename(  # Rename the output column
        F.col('"output_feature_0"'), "PREDICTED_POSITION_LABEL"
    )

    # Join the features and predictions
    final_df = features_df.natural_join(predict_df, "left").select_expr(
        "RACE_YEAR",
        "CIRCUIT_NAME",
        "GRID",
        "CONSTRUCTOR_NAME",
        "DRIVER",
        "DRIVERS_AGE_YEARS",
        "DRIVER_CONFIDENCE",
        "CONSTRUCTOR_RELIABILITY",
        "TOTAL_PIT_STOPS_PER_RACE",
        "PREDICTED_POSITION_LABEL",
    )

    return final_df
