{#-
Goal:
    - Build the features needed for ML model
    - Make text features UPPERCASE and remove spaces for One Hot Encoding in
      f1_preprocess_pipeline.ipynb
Assumptions/Caveats:
    - Feature cleanup is faster in SQL than in Python.
    - More people can read SQL than Python, making the transformation more
      accessible to others.
-#}

{{
  config(
    materialized = 'view',
    )
}}

with

results as (
    select
        {{
            dbt_utils.star(
                from = ref('fct_results'),
                except = ['total_pit_stops_per_race', 'constructor_name']
            )|indent(6)
        }},

        -- Map old names for constructors that are still active
        case
            when upper(constructor_name) = 'FORCE INDIA'
                then 'RACING POINT'
            when upper(constructor_name) = 'SAUBER'
                then 'ALFA ROMEO'
            when upper(constructor_name) = 'LOTUS F1'
                then 'RENAULT'
            when upper(constructor_name) = 'TORO ROSSO'
                then 'ALPHATAURI'
            else upper(constructor_name)
        end as constructor_name,

        coalesce(total_pit_stops_per_race, 0) as total_pit_stops_per_race,

        case
            when position < 4
                then 0  -- podium
            when position < 11
                then 1  -- points
            else 2  -- no points
        end as position_label,

        case
            when position < 4
                then 'podium'
            when position < 11
                then 'points'
            else 'no points'
        end as position_label_text

    from {{ ref("fct_results") }}
    where
        race_year between 2010 and 2020
        and lower(driver) in (
            'daniel ricciardo', 'kevin magnussen', 'carlos sainz',
            'valtteri bottas', 'lance stroll', 'george russell',
            'lando norris', 'sebastian vettel', 'kimi räikkönen',
            'charles leclerc', 'lewis hamilton', 'daniil kvyat',
            'max verstappen', 'pierre gasly', 'alexander albon',
            'sergio pérez', 'esteban ocon', 'antonio giovinazzi',
            'romain grosjean','nicholas latifi'
        )
        and lower(constructor_name) in (
            'renault', 'williams', 'mclaren', 'ferrari', 'mercedes',
            'alphatauri', 'racing point', 'alfa romeo', 'red bull',
            'haas f1 team'
        )
),

driver_confidence as (
    select
        driver_id,
        sum(dnf_flag) as dnf_count,
        count(*) as race_count,
        sum(dnf_flag) / count(*) as dnf_rate,
        1 - (sum(dnf_flag) / count(*)) as driver_confidence
    from results
    group by 1
),

construstor_reliability as (
    select
        constructor_id,
        sum(dnf_flag) as dnf_count,
        count(*) as race_count,
        sum(dnf_flag) / count(*) as dnf_rate,
        1 - (sum(dnf_flag) / count(*)) as constructor_reliability
    from results
    group by 1
),

joined as (
    select
        results.result_id,
        results.race_id,
        results.race_year,
        results.race_round,
        results.circuit_id,
        {{ upper_no_space('results.circuit_name') }} as circuit_name,
        {{ upper_no_space('results.circuit_ref') }} as circuit_ref,
        {{ upper_no_space('results.location') }} as location,
        {{ upper_no_space('results.country') }} as country,
        results.latitude,
        results.longitude,
        results.altitude,
        results.total_pit_stops_per_race,
        results.race_date,
        results.race_time,
        results.driver_id,
        {{ upper_no_space('results.driver') }} as driver,
        results.driver_number,
        results.drivers_age_years,
        {{ upper_no_space('results.driver_nationality') }} as driver_nationality,
        results.constructor_id,
        {{ upper_no_space('results.constructor_name') }} as constructor_name,
        {{ upper_no_space('results.constructor_nationality') }} as constructor_nationality,
        results.grid,
        results.position_label,
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

        -- replace '+'' with 'PLUS_'
        replace(
            {{ upper_no_space('results.status') }},
            '+',
            'PLUS_'
        ) as status,

        results.dnf_flag,
        driver_confidence.driver_confidence,
        construstor_reliability.constructor_reliability
    from results
    left join driver_confidence
        on results.driver_id = driver_confidence.driver_id
    left join construstor_reliability
        on results.constructor_id = construstor_reliability.constructor_id
),

final as (
    select
        result_id,
        race_id,
        race_year,
        circuit_id,
        circuit_name,
        circuit_ref,
        location,
        country,
        latitude,
        longitude,
        altitude,
        total_pit_stops_per_race,
        race_date,
        race_time,
        driver_id,

        -- Translate special characters to english
        upper(
            translate(
                translate(
                    translate(
                        translate(
                            lower(driver),
                            'åãñõç',
                            'aanoc'
                        ),
                        'âêîôû',
                        'aeiou'
                    ),
                    'äëïöü',
                    'aeiou'
                )
                , 'áéíóú',
                'aeiou'
            )
        ) as driver,

        driver_number,
        drivers_age_years,
        driver_nationality,
        constructor_id,
        constructor_name,
        constructor_nationality,
        grid,
        position_label,
        position,
        position_text,
        position_order,
        points,
        laps,
        results_time_formatted,
        results_milliseconds,
        fastest_lap,
        results_rank,
        fastest_lap_time_formatted,
        fastest_lap_speed,
        status_id,
        status,
        dnf_flag,
        driver_confidence,
        constructor_reliability
    from joined
)

select * from final
