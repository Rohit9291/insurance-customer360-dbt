# Insurance Customer 360 --- dbt Data Quality Project

A beginner-friendly dbt project that transforms synthetic insurance
customer data, creates a Customer 360 view, identifies data-quality
exceptions, summarizes data-quality results, and demonstrates
incremental processing.

## Project Overview

Insurance customer data can contain inconsistent formatting, missing
values, duplicate contact details, and invalid business values. This
project uses dbt and DuckDB to build a small, reproducible
transformation workflow and make common data-quality issues visible.

### Goals

-   Learn core dbt concepts through a practical project.
-   Standardize raw customer data in a staging model.
-   Build a Customer 360 model with customer-level policy and premium
    metrics.
-   Identify data-quality exceptions and summarize them.
-   Demonstrate incremental processing using `updated_at`.
-   Practice dbt seeds, models, `ref()`, tests, materializations, and
    command-line workflows.

## Tech Stack

-   **dbt Core:** 1.12.5
-   **dbt adapter:** dbt-duckdb 1.11.0
-   **Database:** DuckDB
-   **Language:** SQL
-   **Input:** Synthetic CSV seed data

## Architecture

``` text
seeds/customers.csv
        |
        v
   customers seed
        |
        v
   stg_customers
        |
        +--------------------+
        |                    |
        v                    v
   customer_360       dq_customer_exceptions
                             |
                             v
                        dq_summary

stg_customers
        |
        v
incremental_customers
```

The exact dependency graph is defined by the models and their `ref()`
calls in the project.

## Project Models

  -----------------------------------------------------------------------
  Model                               Purpose
  ----------------------------------- -----------------------------------
  `stg_customers`                     Standardizes fields, including
                                      trimming names, lowercasing emails,
                                      uppercasing cities, and casting
                                      `updated_at` to a timestamp.

  `customer_360`                      Builds customer-level metrics such
                                      as policy count and premium
                                      totals/averages.

  `dq_customer_exceptions`            Identifies records that violate
                                      selected data-quality rules.

  `dq_summary`                        Aggregates data-quality metrics and
                                      severity counts.

  `incremental_customers`             Demonstrates incremental loading
                                      using `updated_at` and a
                                      `delete+insert` strategy keyed by
                                      `customer_id`.
  -----------------------------------------------------------------------

The `customers` seed loads the source records from
`seeds/customers.csv`.

## Data Quality Rules and Sample Issues

The sample CSV intentionally includes imperfect records to demonstrate
data-quality checks, including:

-   Missing customer name and phone for customer `C004`.
-   A negative premium for customer `C006`.
-   Repeated phone numbers across customer records.

These are deliberate test cases, not claims about real customer data.
The project uses synthetic sample data; do not add real or confidential
customer information to the repository.

## Validation Results

Latest recorded validation:

-   `dbt run`: **5 models passed**.
-   `dbt test`: **8 tests passed; 3 tests failed as expected** against
    the intentionally dirty sample data.
-   `dbt build`: **5 passed, 3 failed, 9 skipped**. The upstream test
    failures cause dependent resources to be skipped under dbt's
    dependency behavior.

The three expected test failures are:

1.  Duplicate phone-number check --- two duplicate results.
2.  Negative premium check --- one result.
3.  Customer-name not-null check --- one result.

The tests are intentionally not weakened just to make the test suite
green. In a production workflow, the team would decide whether each rule
should block downstream processing, warn, or route records for
remediation.

## Incremental Processing: Important Limitation

The incremental model selects rows whose `updated_at` is greater than
the maximum `updated_at` already in the target table. The
`delete+insert` strategy then replaces selected customer keys.

This demonstrates a basic incremental pattern, but it has a limitation:
**an update arriving late with a timestamp earlier than or equal to the
target's maximum timestamp may be missed**. A production implementation
should consider a lookback window, reliable source change tracking, CDC,
or another strategy appropriate to the source data and late-arriving
updates.

## Run the Project

Run commands from the directory containing `dbt_project.yml`.

1.  Activate your Python virtual environment.

2.  Install the required dbt packages if they are not already installed
    in that environment.

3.  Load or refresh the CSV seed:

    ``` bash
    dbt seed --full-refresh
    ```

4.  Run all models:

    ``` bash
    dbt run
    ```

5.  Run tests:

    ``` bash
    dbt test
    ```

6.  Preview a model or query:

    ``` bash
    dbt show --select dq_summary
    ```

7.  Build models and tests together:

    ``` bash
    dbt build
    ```

    Note: with the intentionally dirty sample data, the three expected
    test failures can cause dependent resources to be skipped. See
    **Validation Results** above.

8.  Generate dbt documentation:

    ``` bash
    dbt docs generate
    ```

To inspect available resources:

``` bash
dbt ls
```

## Concepts Practiced

-   dbt project structure and configuration
-   Seeds and CSV source data
-   SQL transformation models
-   `ref()` and model dependencies
-   Staging and downstream model design
-   Data-quality checks and test interpretation
-   Model materialization
-   Incremental models and unique keys
-   `delete+insert` incremental strategy
-   Running, testing, previewing, and documenting a dbt project
-   Reading execution results and understanding dependency-based skips

## Repository Structure

A typical project layout:

``` text
insurance-customer360-dbt/
├── dbt_project.yml
├── models/
│   ├── staging/
│   │   └── stg_customers.sql
│   └── ...
├── seeds/
│   └── customers.csv
├── tests/
│   └── ...
└── README.md
```

Your actual folder names may differ; update this outline to match the
final repository before publishing.

## Future Improvements

-   Add a robust approach for late-arriving updates to incremental
    processing.
-   Add source freshness or ingestion audit checks if the project later
    includes a source system.
-   Add clearer severity and remediation categories for data-quality
    exceptions.
-   Add documentation descriptions for models and columns.
-   Add automated execution through a CI workflow.
-   Expand the synthetic dataset and test cases.

## Disclaimer

This is a learning and portfolio project using synthetic data. It is not
a production-ready insurance data platform.

## Author

**Rohith Nandivada**\
Focus areas: SQL, ETL, Master Data Management (MDM), and Data Quality.
