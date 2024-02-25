with

source as (
    select * from {{ source('formula1', 'sprint_results') }}
),

renamed as (
    select
        result_id,
        race_id,
        driver_id,
        constructor_id,
        number as driver_number,
        grid,

        iff(
            contains("POSITION", '\N'), null, "POSITION"
        ) as driver_position,

        position_text,
        position_order,
        points,
        laps,

        iff(contains("TIME", '\N'), null, "TIME") as sprint_time,

        iff(
            contains(milliseconds, '\N'), null, milliseconds
        ) as milliseconds,

        iff(contains(fastest_lap, '\N'), null, fastest_lap) as fastest_lap,

        iff(
            contains(fastest_lap_time, '\N'),
            null,
            {{ convert_laptime("fastest_lap_time") }}
        ) as fastest_lap_time,

        status_id as status_id
    from source
)

select * from renamed
