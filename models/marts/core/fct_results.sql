with

int_results as (
    select * from {{ ref('int_results') }}
),

circuits as (
    select * from {{ ref('stg_f1_circuits') }}
),

int_pit_stops as (
    select
        race_id,
        driver_id,
        max(total_pit_stops_per_race) as total_pit_stops_per_race
    from {{ ref('int_pit_stops') }}
    group by 1,2
),

base_results as (
    select
        int_results.result_id,
        int_results.race_id,
        int_results.race_year,
        int_results.race_round,
        int_results.circuit_id,
        int_results.circuit_name,
        circuits.circuit_ref,
        circuits.location,
        circuits.country,
        circuits.latitude,
        circuits.longitude,
        circuits.altitude,
        int_pit_stops.total_pit_stops_per_race,
        int_results.race_date,
        int_results.race_time,
        int_results.driver_id,
        int_results.driver,
        int_results.driver_number,
        int_results.drivers_age_years,
        int_results.driver_nationality,
        int_results.constructor_id,
        int_results.constructor_name,
        int_results.constructor_nationality,
        int_results.grid,
        int_results.position,
        int_results.position_text,
        int_results.position_order,
        int_results.points,
        int_results.laps,
        int_results.results_time_formatted,
        int_results.results_milliseconds,
        int_results.fastest_lap,
        int_results.results_rank,
        int_results.fastest_lap_time_formatted,
        int_results.fastest_lap_speed,
        int_results.status_id,
        int_results.status,
        int_results.dnf_flag
    from int_results
    left join circuits
        on int_results.circuit_id=circuits.circuit_id
    left join int_pit_stops
        on int_results.driver_id=int_pit_stops.driver_id and int_results.race_id=int_pit_stops.race_id
)

select * from base_results
