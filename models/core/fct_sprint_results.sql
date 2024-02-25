{{
  config(
    materialized = 'table',
    )
}}

with

sprint_results as (
    select * from {{ ref('stg_f1_sprint_results') }}
),

final as (
    select
        result_id,
        race_id,
        driver_id,
        constructor_id,
        driver_number,
        grid,
        driver_position,
        position_text,
        position_order,
        points,
        laps,
        sprint_time,
        milliseconds,
        fastest_lap,
        fastest_lap_time,
        status_id
    from sprint_results
)

select * from final
