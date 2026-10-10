WITH customers AS (

    SELECT *
    FROM {{ ref('stg_customers') }}

),

exceptions AS (

    SELECT *
    FROM {{ ref('dq_customer_exceptions') }}

),

metrics AS (

    SELECT
        COUNT(DISTINCT CASE
            WHEN dq_rule IS NOT NULL THEN customer_id
        END) AS customers_with_issues,

        COUNT(*) AS total_issue_occurrences,

        COUNT(CASE
            WHEN severity = 'HIGH' THEN 1
        END) AS high_severity_issues,

        COUNT(CASE
            WHEN severity = 'MEDIUM' THEN 1
        END) AS medium_severity_issues,

        COUNT(CASE
            WHEN severity = 'LOW' THEN 1
        END) AS low_severity_issues

    FROM exceptions

)

SELECT
    (SELECT COUNT(*) FROM customers) AS total_records,

    (SELECT COUNT(DISTINCT customer_id) FROM customers) AS unique_customers,

    customers_with_issues,

    total_issue_occurrences,

    high_severity_issues,

    medium_severity_issues,

    low_severity_issues,

    ROUND(
        100.0 * (
            (SELECT COUNT(*) FROM customers) - customers_with_issues
        )
        / NULLIF((SELECT COUNT(*) FROM customers), 0),
        2
    ) AS data_quality_percentage

FROM metrics
