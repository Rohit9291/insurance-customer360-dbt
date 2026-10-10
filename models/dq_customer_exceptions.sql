WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

duplicate_phones AS (

    SELECT
        phone
    FROM customers
    WHERE phone IS NOT NULL
    GROUP BY phone
    HAVING COUNT(*) > 1

),

dq_exceptions AS (

    -- Rule 1: Missing customer name
    SELECT
        customer_id,
        customer_name,
        email,
        phone,
        city,
        policy_id,
        premium,
        'MISSING_CUSTOMER_NAME' AS dq_rule,
        'HIGH' AS severity
    FROM customers
    WHERE customer_name IS NULL

    UNION ALL

    -- Rule 2: Missing phone
    SELECT
        customer_id,
        customer_name,
        email,
        phone,
        city,
        policy_id,
        premium,
        'MISSING_PHONE' AS dq_rule,
        'HIGH' AS severity
    FROM customers
    WHERE phone IS NULL

    UNION ALL

    -- Rule 3: Negative premium
    SELECT
        customer_id,
        customer_name,
        email,
        phone,
        city,
        policy_id,
        premium,
        'NEGATIVE_PREMIUM' AS dq_rule,
        'HIGH' AS severity
    FROM customers
    WHERE premium < 0

    UNION ALL

    -- Rule 4: Duplicate phone
    SELECT
        c.customer_id,
        c.customer_name,
        c.email,
        c.phone,
        c.city,
        c.policy_id,
        c.premium,
        'DUPLICATE_PHONE' AS dq_rule,
        'MEDIUM' AS severity
    FROM customers c
    INNER JOIN duplicate_phones d
        ON c.phone = d.phone

)

SELECT *
FROM dq_exceptions
