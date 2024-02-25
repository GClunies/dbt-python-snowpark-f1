with

source as (select * from {{ source('formula1', 'pit_stops') }}),

renamed as (
    select
        {{
            dbt_utils.generate_surrogate_key(
                ["race_id", "driver_id", "stop"]
            )
        }} as pitstop_id,

        race_id,
        driver_id,
        stop as stop_number,
        lap,
        "TIME" as pit_stop_time,
        duration as pit_stop_duration_seconds,
        {{ convert_laptime("pit_stop_duration_seconds") }} as pit_stop_duration,
        milliseconds as pit_stop_milliseconds
    from source
)

select * from renamed
