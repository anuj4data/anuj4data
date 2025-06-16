{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

WITH category_monthly AS (
    SELECT
        category,
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM {{ ref('fact_orders') }}
    WHERE EXTRACT(YEAR FROM order_date) = 2019
    GROUP BY 1, 2
),

category_growth AS (
    SELECT
        category,
        month,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY category ORDER BY month) AS previous_month_sales,
        total_sales - LAG(total_sales) OVER (PARTITION BY category ORDER BY month) AS absolute_change,
        ROUND((total_sales - LAG(total_sales) OVER (PARTITION BY category ORDER BY month)) / 
            NULLIF(LAG(total_sales) OVER (PARTITION BY category ORDER BY month), 0) * 100, 2) AS percentage_change
    FROM category_monthly
)

SELECT
    category,
    month,
    total_sales,
    previous_month_sales,
    absolute_change,
    percentage_change,
    SUM(total_sales) OVER (PARTITION BY category ORDER BY month) AS running_total
FROM category_growth
ORDER BY category, month