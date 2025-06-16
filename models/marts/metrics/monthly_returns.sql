{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

SELECT
    DATE_TRUNC('month', order_date) AS month,
    category,
    SUM(return_count) AS total_returns,
    COUNT(DISTINCT CASE WHEN return_count > 0 THEN order_id END) AS returned_orders,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(return_count) / NULLIF(SUM(quantity), 0) * 100, 2) AS return_rate_percentage,
    ROUND(COUNT(DISTINCT CASE WHEN return_count > 0 THEN order_id END) / 
        NULLIF(COUNT(DISTINCT order_id), 0) * 100, 2) AS order_return_rate
FROM {{ ref('fact_returns') }}
WHERE EXTRACT(YEAR FROM order_date) = 2019
GROUP BY 1, 2
ORDER BY 1, 2