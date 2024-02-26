with

source  as (
    select * from {{ source('formula1','constructors') }}
),

renamed as (
    select
        constructorid::int as constructor_id,
        constructorref::text as constructor_ref,
        name::text as constructor_name,
        nationality::text as constructor_nationality
        -- omit the url
    from source
)

select * from renamed
