{{
  config(
    materialized = 'table',
    )
}}

with

pit_stops as (
    select * from {{ ref('stg_pit_stops') }}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key(['race_id', 'driver_id', 'stop_number'])
        }} as pitstop_id,

        race_id,
        driver_id,
        stop_number,
        lap,
        pit_stop_time,
        pit_stop_duration_seconds,
        pit_stop_duration,
        pit_stop_milliseconds,

        max(stop_number) over (
            partition by race_id, driver_id
        ) as total_pit_stops_per_race

    from pit_stops
)

select * from pitstops
