{{
  config(
    materialized = 'table',
    )
}}

with

driver_standings as (
    select * from {{ ref('stg_driver_standings') }}
),

final as (
    select
        driver_standings_id,
        race_id,
        driver_id,
        driver_points,
        driver_position,
        position_text,
        driver_wins
    from driver_standings
)

select * from final
