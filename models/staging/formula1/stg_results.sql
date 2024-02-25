with

results as (
    select * from {{ source('formula1', 'results') }}
),

renamed as (
    select
        result_id,
        race_id,
        driver_id,
        constructor_id,
        number as driver_number,
        grid,
        --position::int as position,
        iff(contains(position, '\N'), null, position) as driver_position,
        position_text,
        position_order,
        points,
        laps,
        iff(contains("TIME", '\N'), null, "TIME") as race_time,
        iff(contains(milliseconds, '\N'), null, milliseconds) as milliseconds,
        iff(contains(fastest_lap, '\N'), null, fastest_lap) as fastest_lap,
        "RANK" as driver_rank,
        iff(contains(fastest_lap_time, '\N'),null,{{ convert_laptime("fastest_lap_time") }}) as fastest_lap_time,
        iff(contains(fastest_lap_speed, '\N'), null, fastest_lap_speed) as fastest_lap_speed,
        status_id
    from results
)

select * from renamed
