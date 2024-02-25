{{
  config(
    materialized = "incremental",
    unique_key = "result_id",
    tags = ["race", "laptimes"],
    )
}}

with

results as (
    select * from {{ ref('stg_results') }}
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['result_id']) }} as fct_result_id,
        result_id,
        race_id,
        driver_id,
        constructor_id,
        driver_number,
        grid,
        driver_position,
        position_text,
        position_order,
        points,
        laps,
        race_time,
        milliseconds,
        fastest_lap,
        driver_rank,
        fastest_lap_time,
        fastest_lap_speed,
        status_id
    from results
)

select * from final
