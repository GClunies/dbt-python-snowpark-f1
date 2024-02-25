with

source as (
    select * from {{ source('formula1', 'status') }}
),

renamed as (
    select
        status_id as status_id,
        status
    from source
)

select * from renamed
