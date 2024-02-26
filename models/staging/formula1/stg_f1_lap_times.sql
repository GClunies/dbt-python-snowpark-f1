with

source  as (
    select * from {{ source('formula1','lap_times') }}
),

renamed as (
    select
        {{
            dbt_utils.generate_surrogate_key(["raceid", "driverid", "lap"])
        }}::text as lap_time_id,

        raceid::int as race_id,
        driverid::int as driver_id,
        lap::int as lap,
        position::int as position,
        time::text as lap_time_formatted,
        milliseconds::int as lap_time_milliseconds
    from source
)

select * from renamed
