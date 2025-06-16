{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
    order_id,
    TRY_TO_DATE(order_date) AS order_date,
    TRY_TO_DATE(ship_date) AS ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
FROM {{ source('raw', 'orders') }}
