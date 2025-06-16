{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

SELECT
    DATE_TRUNC('month', order_date) AS month,
    category,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(quantity) AS total_quantity,
    SUM(profit) AS total_profit,
    SUM(sales) / NULLIF(COUNT(DISTINCT order_id), 0) AS avg_order_value
FROM {{ ref('fact_orders') }}
WHERE EXTRACT(YEAR FROM order_date) = 2019
GROUP BY 1, 2
ORDER BY 1, 2