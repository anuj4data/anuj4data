{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

SELECT
    o.order_id,
    o.order_date,
    o.region,
    o.category,
    o.sub_category,
    COALESCE(r.return_count, 0) AS return_count,
    o.sales,
    o.quantity,
    CASE 
        WHEN r.return_count > 0 THEN TRUE 
        ELSE FALSE 
    END AS is_returned
FROM {{ ref('fact_orders') }} o
LEFT JOIN {{ ref('stg_returns') }} r ON o.order_id = r.order_id