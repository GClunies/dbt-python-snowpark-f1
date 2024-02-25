with

status as (
    SELECT * FROM {{ source('formula1','status') }}
),

renamed as (
    select
        status_id as status_id,
        status
    from status
)

select * from renamed
