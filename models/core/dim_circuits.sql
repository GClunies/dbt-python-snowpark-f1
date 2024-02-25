{{
  config(
    materialized = 'table',
    )
}}

with

circuits as (
    select * from {{ ref('stg_circuits') }}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key(['circuit_id'])
        }} as dim_circuit_id,

        *
    from circuits
)

select * from final
