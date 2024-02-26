with

results as (
    select * from {{ ref('stg_f1_results') }}
),

races as (
    select * from {{ ref('stg_f1_races') }}
),

drivers as (
    select * from {{ ref('stg_f1_drivers') }}
),

constructors as (
    select * from {{ ref('stg_f1_constructors') }}
),

status as (
    select * from {{ ref('stg_f1_status') }}
),

int_results as (
    select
        results.result_id,
        results.race_id,
        races.race_year,
        races.race_round,
        races.circuit_id,
        races.circuit_name,
        races.race_date,
        races.race_time,
        results.driver_id,
        results.driver_number,
        drivers.forename ||' '|| drivers.surname as driver,

        cast(
            {{
                dbt.datediff(
                    "drivers.date_of_birth",
                    "races.race_date",
                    "year"
                )
            }}
            as int
        ) as drivers_age_years,

        drivers.driver_nationality,
        results.constructor_id,
        constructors.constructor_name,
        constructors.constructor_nationality,
        results.grid,
        results.position,
        results.position_text,
        results.position_order,
        results.points,
        results.laps,
        results.results_time_formatted,
        results.results_milliseconds,
        results.fastest_lap,
        results.results_rank,
        results.fastest_lap_time_formatted,
        results.fastest_lap_speed,
        results.status_id,
        status.status,

        case
            when results.position is null
                then 1
            else 0
        end as dnf_flag

    from results
    left join races
        on results.race_id=races.race_id
    left join drivers
        on results.driver_id = drivers.driver_id
    left join constructors
        on results.constructor_id = constructors.constructor_id
    left join status
        on results.status_id = status.status_id
)

select * from int_results
