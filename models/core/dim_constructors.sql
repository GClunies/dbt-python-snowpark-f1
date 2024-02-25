{{
  config(
    materialized = 'table',
    )
}}

with

constructors as (
    select * from {{ ref('stg_f1_constructors') }}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key(['constructor_id'])
        }} as dim_constructor_id,

        constructor_id,
        constructor_ref,
        constructor_name,
        constructor_nationality
        --constructor_url
    from constructors
)

select * from final
