with

source  as (
    select * from {{ source('formula1','circuits') }}
),

renamed as (
    select
        circuitid::int as circuit_id,
        circuitref::text as circuit_ref,
        name::text as circuit_name,
        location::text as location,
        country::text as country,
        lat::number as latitude,
        lng::number as longitude,
        alt::number as altitude
        -- omit the url
    from source
)
select * from renamed
