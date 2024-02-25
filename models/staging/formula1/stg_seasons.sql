with
seasons as (
    select * from {{ source('formula1', 'seasons') }}
),

renamed as (
    select
        "YEAR" as season_year,
        url as season_url
    from seasons
)

select * from renamed
