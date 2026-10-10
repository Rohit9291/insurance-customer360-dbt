SELECT
    phone,
    COUNT(*) AS customer_count
FROM {{ ref('stg_customers') }}
WHERE phone IS NOT NULL
GROUP BY phone
HAVING COUNT(*) > 1
