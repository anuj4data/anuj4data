{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
    regional_manager,
    region
FROM {{ source('raw', 'people') }}