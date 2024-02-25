with

lap_times as (
    select * from {{ source('formula1', 'lap_times') }}
),

renamed as (
    select
        {{
            dbt_utils.generate_surrogate_key(["race_id", "driver_id", "lap"])
        }} as lap_times_id,

        race_id,
        driver_id,
        lap,
        "POSITION" as driver_position,
        "TIME" as lap_time_formatted,
        {{ convert_laptime("lap_time_formatted") }} as official_laptime,
        milliseconds as lap_time_milliseconds
    from lap_times
)

select * from renamed
