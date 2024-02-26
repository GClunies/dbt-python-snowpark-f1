with

source  as (
    select * from {{ source('formula1','races') }}
),

renamed as (
    select
        raceid::int as race_id,
        year::int as race_year,
        round::int as race_round,
        circuitid::int as circuit_id,
        name::text as circuit_name,
        date::date as race_date,
        to_time(time) as race_time,
        -- omit the url
        fp1_date::date as free_practice_1_date,
        fp1_time::time as free_practice_1_time,
        fp2_date::date as free_practice_2_date,
        fp2_time::time as free_practice_2_time,
        fp3_date::date as free_practice_3_date,
        fp3_time::time as free_practice_3_time,
        quali_date::date as qualifying_date,
        quali_time::time as qualifying_time,
        sprint_date::date as sprint_date,
        sprint_time::time as sprint_time
    from source
)

select * from renamed
