{{
  config(
    materialized = 'table',
    )
}}

with

seasons as (
    select * from {{ ref('stg_seasons') }}
),

final as (
    select
        season_year,
        season_url
    from seasons
)

select * from final
