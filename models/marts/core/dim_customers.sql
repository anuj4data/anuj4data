{{
  config(
    materialized='table',
    schema='analytics',
    unique_key='customer_id'
  )
}}

SELECT
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
FROM {{ ref('stg_orders') }}
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8