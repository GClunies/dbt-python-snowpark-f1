{{
  config(
    materialized = 'table',
    )
}}

with

constructor_standings as (
    select * from {{ ref('stg_constructor_standings') }}
),

final as (
    select
        constructor_standings_id,
        race_id,
        constructor_id,
        points,
        constructor_position,
        position_text,
        wins
    from constructor_standings
)

select * from final
