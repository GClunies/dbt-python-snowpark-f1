with

source  as (
    select * from {{ source('formula1','lap_times') }}
),

renamed as (
    select
        {{
            dbt_utils.generate_surrogate_key(["race_id", "driver_id", "lap"])
        }} as lap_time_id,

        race_id,
        driver_id,
        lap,
        position,
        time as lap_time_formatted,
        milliseconds as lap_time_milliseconds
    from source
)

select * from renamed
