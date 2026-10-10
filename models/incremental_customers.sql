{{ config(
    materialized='incremental',
    unique_key='customer_id',
    incremental_strategy='delete+insert'
) }}

SELECT
    customer_id,
    customer_name,
    email,
    phone,
    city,
    premium,
    updated_at

FROM {{ ref('stg_customers') }}

{% if is_incremental() %}

WHERE updated_at > (
    SELECT COALESCE(MAX(updated_at), TIMESTAMP '1900-01-01 00:00:00')
    FROM {{ this }}
)

{% endif %}
