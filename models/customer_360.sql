{{ config(materialized='table') }}
SELECT
    customer_id,
    customer_name,
    email,
    phone,
    city,

    COUNT(policy_id) AS policy_count,
    SUM(premium) AS total_premium,
    AVG(premium) AS average_premium

FROM {{ ref('stg_customers') }}

GROUP BY
    customer_id,
    customer_name,
    email,
    phone,
    city
