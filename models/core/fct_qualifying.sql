{{
  config(
    materialized = 'table',
    enabled = false,
    )
}}

with

qualifying as (
    select * from {{ ref('stg_f1_qualifying') }}
),

final as (
    select
        qualifying_id,
        race_id,
        driver_id,
        constructor_id,
        driver_number,
        qualifying_position,
        q1_time,
        q2_time,
        q3_time
    from qualifying
)

select * from final
