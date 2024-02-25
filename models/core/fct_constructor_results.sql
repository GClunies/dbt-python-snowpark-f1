{{
  config(
    materialized = 'table',
    )
}}

with

constructor_results as (
    select * from {{ ref('stg_f1_constructor_results') }}
),

final as (
    select
        constructor_results_id,
        race_id,
        constructor_id,
        constructor_points,
        status
    from constructor_results
)

select * from final
