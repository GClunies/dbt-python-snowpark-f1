{{
  config(
    materialized = 'table',
    )
}}

with

races as (
    select * from {{ ref('stg_races') }}
),

final as (
    select
        race_id,
        race_year,
        race_round,
        circuit_id,
        race_name,
        race_date,
        race_time,
        race_url,
        fp1_date,
        fp1_time,
        fp2_date,
        fp2_time,
        fp3_date,
        fp3_time,
        quali_date,
        quali_time,
        sprint_date,
        sprint_time
    from races
)

select * from races
