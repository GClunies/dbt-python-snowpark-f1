with

source  as (
    select * from {{ source('formula1','status') }}
),

renamed as (
    select
        statusid::int as status_id,
        status::text as status
    from source
)

select * from renamed
