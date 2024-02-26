# import numpy as np
# import pandas as pd
import snowflake.snowpark as snowpark


def model(dbt, session: snowpark.Session) -> snowpark.DataFrame:
    # dbt configuration
    dbt.config(packages=["pandas", "numpy"])

    # get upstream data
    pit_stops_df = dbt.ref("INT_PIT_STOPS__JOIN_RESULTS")

    # provide year so we do not hardcode dates
    year = 2021

    # describe the data
    pit_stops_df["PIT_STOP_SECONDS"] = pit_stops_df["PIT_STOP_MILLISECONDS"] / 1000
    fastest_pit_stops = (
        pit_stops_df[(pit_stops_df["RACE_YEAR"] == year)]
        .group_by("CONSTRUCTOR_NAME")["PIT_STOP_SECONDS"]
        .describe()
        .sort("mean")
    )

    return fastest_pit_stops
