with

source as (
    select * from {{ source('formula1', 'constructor_results') }}
),

renamed as (
    select
        constructor_results_id,
        race_id,
        constructor_id,
        points as constructor_points,
        iff(contains(status, '\N'), null, status) as status
    from source
)

select * from renamed