with

source  as (
    select * from {{ source('formula1','drivers') }}
),

renamed as (
    select
        driverid::int as driver_id,
        driverref::text as driver_ref,
        number::number as driver_number,
        upper(code)::text as driver_code,
        forename::text as forename,
        surname::text as surname,
        dob::date as date_of_birth,
        nationality::text as driver_nationality
        -- omit the url
    from source
)

select * from renamed
