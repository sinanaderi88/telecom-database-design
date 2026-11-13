# Database Implementation

## 1. Implementation Overview

The logical database design was implemented using PostgreSQL 16. The database schema was initially modeled using pgModeler 1.2.3, and the generated SQL DDL was used to create the physical database structure.

**Implementation Environment**

| Component | Version / Configuration |
|---|---|
| Operating System | Ubuntu 24.04 LTS |
| Database Management System | PostgreSQL 16 |
| Database Modeling Tool | pgModeler 1.2.3 |
| Database Name | `telecom_db` |
| Schema | `telecom` |
| Database User | `telecom_user` |

## 2. Physical Database Creation

The physical database consists of seven tables:

- `customer`
- `subscription`
- `plan`
- `services`
- `service_plan`
- `subscription_services`
- `subscription_service_history`

Primary keys and foreign key constraints were created according to the logical database design.

The database schema was generated from the pgModeler model and deployed to PostgreSQL using the exported SQL script.

The implementation includes:

- Primary key constraints.
- Foreign key constraints.
- Composite primary keys for junction tables.
- Appropriate PostgreSQL data types.
- Boolean attributes for binary customer and service-related properties.

## 3. Data Loading Strategy

The IBM Telco Customer Churn dataset was used as the initial data source.

The original CSV file contains 7,043 customer records and 21 columns.

A staging table was created to temporarily hold the source data before transferring it into the normalized database structure.

### 3.1 Staging Table

The staging table, `stg_telco_customer_churn`, was created as a temporary table within the PostgreSQL session.

All source columns were initially defined as `TEXT` to preserve the imported values and defer type conversion until the target-table insertion stage.

The CSV file was loaded using PostgreSQL's `\copy` command.

**Imported source records:** 7,043

### 3.2 Customer Data

Customer information was transferred from the staging table into `telecom.customer`.

The following source attributes were mapped:

- `customerID` → `customer_id`
- `gender` → `gender`
- `SeniorCitizen` → `senior_citizen`
- `Partner` → `partner`
- `Dependents` → `dependents`

Binary source values were converted to PostgreSQL BOOLEAN:

| Source Value | PostgreSQL Value |
|---|---|
| 1 | TRUE |
| 0 | FALSE |
| Yes | TRUE |
| No | FALSE |

This conversion represents data type mapping based on the target database design.

**Inserted records:** 7,043

### 3.3 Plan Data

The source dataset contains three contract types:

- Month-to-month
- One year
- Two year

These values were represented as three records in the `plan` table.

The `plan_id` attribute was introduced as a surrogate primary key because the original dataset does not provide a dedicated plan identifier.

**Inserted records:** 3

### 3.4 Subscription Data

A subscription record was created for each customer in the source dataset.

The contract type was mapped to its corresponding `plan_id`.

The `subscription_id` values were generated using the SQL `ROW_NUMBER()` window function.

The `tenure` attribute was converted to INTEGER.

The `contract_start_date` attribute was set to NULL because the source dataset does not contain an actual contract start date.

**Inserted records:** 7,043

### 3.5 Service Catalog

Nine service definitions were inserted into the `services` table.

| Service ID | Service Name | Category |
|---:|---|---|
| 1 | Phone Service | Telephony |
| 2 | Multiple Lines | Telephony |
| 3 | Internet | Internet |
| 4 | Online Security | Internet |
| 5 | Online Backup | Internet |
| 6 | Device Protection | Internet |
| 7 | Tech Support | Internet |
| 8 | Streaming TV | Entertainment |
| 9 | Streaming Movies | Entertainment |

**Inserted records:** 9

### 3.6 Subscription Services

The `subscription_services` table stores the services associated with individual subscriptions.

Service records were generated from the corresponding service attributes in the staging table.

Only services marked as `Yes` in the source dataset were inserted.

For each inserted record, the service status was initialized as `Active`.

This represents the current service information available in the source dataset; historical activation and deactivation events are not provided.

**Inserted records:** 29,202

### 3.7 Plan-Service Relationships

The `service_plan` junction table represents the relationship between plans and available services.

For the initial implementation, all nine services were associated with all three plans, producing 27 plan-service combinations.

The following default values were applied:

- `is_included = FALSE`
- `is_optional = TRUE`

These values represent an initial modeling assumption rather than business rules derived from the IBM dataset.

**Inserted records:** 27

### 3.8 Subscription Service History

The `subscription_service_history` table was created to support future tracking of service status changes.

It remains empty in the initial implementation because the source dataset does not contain historical service status events.

This is an expected result rather than a data-loading failure.

## 4. Data Validation

After loading the source data, record counts were checked across all seven tables.

### 4.1 Record Count Validation

| Table | Record Count |
|---|---:|
| customer | 7,043 |
| subscription | 7,043 |
| plan | 3 |
| services | 9 |
| service_plan | 27 |
| subscription_services | 29,202 |
| subscription_service_history | 0 |

### 4.2 Service Distribution Validation

The number of records associated with each service was also queried from the database.

| Service | Records |
|---|---:|
| Phone Service | 6,361 |
| Multiple Lines | 2,971 |
| Internet | 5,517 |
| Online Security | 2,019 |
| Online Backup | 2,429 |
| Device Protection | 2,422 |
| Tech Support | 2,044 |
| Streaming TV | 2,707 |
| Streaming Movies | 2,732 |

The service distribution query confirmed that records were successfully inserted into the subscription-service relationship table.

## 5. Implementation Notes and Limitations

The following implementation decisions and limitations should be considered when interpreting the current database:

1. The IBM Telco Customer Churn dataset provides customer, subscription, contract, and service information. It does not contain actual Call Detail Records (CDRs), network usage logs, or detailed billing transactions.

2. The `contract_start_date` attribute remains NULL because the source dataset does not provide this information.

3. The `subscription_service_history` table is currently empty because historical service changes are not available in the source data.

4. The initial plan-service mapping is an implementation assumption and should be refined when actual product and service eligibility rules become available.

5. The current implementation represents one subscription per customer, based on the structure of the source dataset. The relational design supports a one-to-many relationship between customers and subscriptions.

6. pgModeler generated separate foreign-key columns for some relationships. These columns were retained in the initial physical implementation, and the corresponding values were populated consistently with the original key columns. This is a potential area for future schema refinement.

## 6. Implementation Status

The initial physical database implementation and source-data loading have been completed.

The seven-table schema has been deployed to PostgreSQL, the initial dataset has been loaded, and record-count and service-distribution validation queries have been executed.

Further improvements may include refining relationship-generated foreign-key columns, expanding historical service tracking, and introducing additional telecom usage and billing datasets.

---

**Project:** Telecom Database Design

**Database:** PostgreSQL 16

**Schema:** `telecom`
