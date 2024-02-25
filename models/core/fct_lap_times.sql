{{
  config(
    materialized = 'table',
    )
}}

with

lap_times as (
    select * from {{ ref('stg_f1_lap_times') }}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key(['race_id', 'driver_id', 'lap'])
        }} as lap_times_id,

        race_id,
        driver_id,
        lap,
        driver_position,
        lap_time_formatted,
        official_laptime,
        lap_time_milliseconds
    from lap_times
)

select * from final
