{{
  config(
    materialized = 'table',
    )
}}

with

drivers as (
    select * from {{ ref('stg_f1_drivers') }}
),

final as (
    select
        driver_id,
        driver_ref,
        driver_number,
        driver_code,
        forename,
        surname,
        date_of_birth,
        driver_nationality
        -- driver_url
    from drivers
)

select * from final
