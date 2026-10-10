# Essential dbt Commands — Insurance Customer 360

A practical reference for the dbt Core + DuckDB project.

## 1. Setup and validation

```bash
dbt --version
dbt debug
dbt ls
```

- `dbt --version` — Check installed dbt version.
- `dbt debug` — Validate project configuration and database connection.
- `dbt ls` — List project resources.

## 2. Load seed data

```bash
dbt seed
dbt seed --full-refresh
```

- `dbt seed` — Load CSV files from the `seeds/` directory into the database.
- `dbt seed --full-refresh` — Rebuild seed tables from the CSV files.

## 3. Run models

```bash
dbt run
dbt run --select stg_customers
dbt run --select customer_360
dbt run --select +customer_360
```

- `dbt run` — Execute all selected models.
- `--select stg_customers` — Run a specific model.
- `--select customer_360` — Run the Customer 360 model.
- `--select +customer_360` — Run the selected model and its upstream dependencies.

## 4. Test data quality

```bash
dbt test
dbt test --select stg_customers
```

- `dbt test` — Execute configured data tests.
- `dbt test --select stg_customers` — Run tests associated with the selected model.

## 5. Build models and tests

```bash
dbt build
```

Runs applicable resources in dependency order, including models, tests, and seeds when selected.

**Note:** In this project, some tests intentionally fail because the sample data contains duplicate phone numbers, a missing customer name, and a negative premium. These failures demonstrate data quality validation.

## 6. Inspect model results

```bash
dbt show --select dq_summary
dbt show --select customer_360
```

Preview query results from selected models.

## 7. Incremental processing

```bash
dbt run --select incremental_customers
dbt run --select incremental_customers --full-refresh
```

- The first command runs the incremental model.
- `--full-refresh` rebuilds the incremental model from its source rather than applying incremental processing.

**Important:** The current model filters on `updated_at` greater than the maximum timestamp in the target. Late-arriving updates with older timestamps may therefore be missed.

## 8. Documentation

```bash
dbt docs generate
dbt docs serve
```

- `dbt docs generate` — Generate project documentation and lineage metadata.
- `dbt docs serve` — Serve the generated documentation locally.

## 9. Clean generated artifacts

```bash
dbt clean
```

Remove generated directories configured for cleaning, such as `target/` and `dbt_packages/`, depending on project configuration.

## Recommended execution workflow

```bash
dbt debug
dbt seed
dbt run
dbt test
dbt show --select dq_summary
```

Run commands from the project directory containing `dbt_project.yml`, with the project's Python virtual environment activated.

**Project stack:** dbt Core · DuckDB · SQL · Data Quality · Incremental Models · Insurance Customer 360
