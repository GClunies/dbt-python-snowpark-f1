with

source as (
    select * from {{ source('formula1', 'constructor_standings') }}
),

renamed as (
    select
        constructor_standings_id,
        race_id,
        constructor_id,
        points,
        "POSITION" as constructor_position,
        position_text,
        wins
    from source
)

select * from renamed