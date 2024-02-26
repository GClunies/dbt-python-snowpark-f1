with

source  as (
    select * from {{ source('formula1','results') }}
),

renamed as (
    select
        resultid::int as result_id,
        raceid::int as race_id,
        driverid::int as driver_id,
        constructorid::int as constructor_id,
        number::int as driver_number,
        grid::int as grid,
        position::int as position,
        positiontext::text as position_text,
        positionorder::int as position_order,
        points::int as points,
        laps::int as laps,
        time::text as results_time_formatted,
        milliseconds::int as results_milliseconds,
        fastestlap::int as fastest_lap,
        rank::int as results_rank,
        fastestlaptime::text as fastest_lap_time_formatted,
        fastestlapspeed::decimal(6,3) as fastest_lap_speed,
        statusid::int as status_id
    from source
)

select * from renamed
