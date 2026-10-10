SELECT *
FROM {{ ref('stg_customers') }}
WHERE premium < 0
