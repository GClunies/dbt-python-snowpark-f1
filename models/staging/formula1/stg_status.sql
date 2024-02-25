with

statuses as (
    select * from {{ source('formula1','status') }}
),

renamed as (
    select
        status_id as status_id,
        status
    from statuses
)

select * from renamed
