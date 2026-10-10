
SELECT
    customer_id,
    TRIM(customer_name) AS customer_name,
    LOWER(TRIM(email)) AS email,
    phone,
    UPPER(TRIM(city)) AS city,
    policy_id,
    premium,
    CAST(updated_at AS TIMESTAMP) AS updated_at
FROM {{ ref('customers') }}
