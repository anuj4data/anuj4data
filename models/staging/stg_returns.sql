{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
    order_id,
    COUNT(*) AS return_count
FROM {{ source('raw', 'returns') }}
WHERE returned = 'Yes'
GROUP BY order_id