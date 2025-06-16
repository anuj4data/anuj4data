{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM {{ ref('fact_orders') }}
    WHERE EXTRACT(YEAR FROM order_date) = 2019
    GROUP BY 1
)

SELECT
    month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY month) AS absolute_change,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY month)) / 
        NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100, 2) AS percentage_change
FROM monthly_sales
ORDER BY month