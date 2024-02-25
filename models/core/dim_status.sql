{{
  config(
    materialized = 'table',
    )
}}

with

statuses as (
    select * from {{ ref('stg_status') }}
),

final as (
    select
        status_id,
        status
    from statuses
)

select * from final
