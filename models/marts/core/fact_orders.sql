{{
  config(
    materialized='table',
    schema='analytics',
    partition_by={
      "field": "order_date",
      "data_type": "date",
      "granularity": "month"
    },
    cluster_by=["region", "category"]
  )
}}

SELECT
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    o.customer_id,
    o.product_id,
    o.region,
    o.state,
    o.category,
    o.sub_category,
    o.sales,
    o.quantity,
    o.discount,
    o.profit,
    p.regional_manager
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_people') }} p ON o.region = p.region