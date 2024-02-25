with

source as (
    select * from {{ source('formula1', 'driver_standings') }}
),

renamed as (
    select
        driver_standings_id,
        race_id,
        driver_id,
        points as driver_points,
        "POSITION" as driver_position,
        position_text,
        wins as driver_wins
    from source
)

select * from renamed
