with

lap_times as (
    select * from {{ ref('stg_f1_lap_times') }}
),

races as (
    select * from {{ ref('stg_f1_races') }}
),

expanded_lap_times_by_year as (
    select
        lap_times.race_id,
        lap_times.driver_id,
        races.race_year,
        lap_times.lap,
        lap_times.lap_time_milliseconds
    from lap_times
    left join races
        on lap_times.race_id = races.race_id
    where lap_time_milliseconds is not null
)

select * from expanded_lap_times_by_year
