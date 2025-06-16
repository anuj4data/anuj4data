{{
  config(
    materialized='table',
    schema='analytics'
  )
}}

WITH region_sales AS (
    SELECT
        region,
        regional_manager,
        SUM(sales) AS total_sales,
        RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
    FROM {{ ref('fact_orders') }}
    WHERE EXTRACT(YEAR FROM order_date) = 2019
    GROUP BY 1, 2
),

state_sales AS (
    SELECT
        state,
        region,
        SUM(sales) AS total_sales,
        RANK() OVER (PARTITION BY region ORDER BY SUM(sales) DESC) AS state_rank_in_region,
        RANK() OVER (ORDER BY SUM(sales) DESC) AS state_rank_overall
    FROM {{ ref('fact_orders') }}
    WHERE EXTRACT(YEAR FROM order_date) = 2019
    GROUP BY 1, 2
)

SELECT
    'region' AS geography_type,
    region AS geography_name,
    regional_manager,
    total_sales,
    sales_rank AS rank
FROM region_sales

UNION ALL

SELECT
    'state' AS geography_type,
    state AS geography_name,
    NULL AS regional_manager,
    total_sales,
    state_rank_overall AS rank
FROM state_sales
ORDER BY geography_type, rank