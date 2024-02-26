with

source  as (
    select * from {{ source('formula1','pit_stops') }}
),

renamed as (
    select
        {{
            dbt_utils.generate_surrogate_key(
                ["raceid", "driverid", "stop"]
            )
        }}::text as pitstop_id,

        raceid::int as race_id,
        driverid::int as driver_id,
        stop::int as stop_number,
        lap::int as lap,
        time::text as lap_time_formatted,
        duration::text as pit_stop_duration_seconds,
        milliseconds::int as pit_stop_milliseconds
    from source
)

select *
from renamed
order by pit_stop_duration_seconds desc
