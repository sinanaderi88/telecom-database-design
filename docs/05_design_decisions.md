# Database Design Decisions

## 1. Overview

This document records the key technical decisions made during the design and implementation of the Telecom Database.

It explains the rationale behind the selected database structures, data types, relationships, and implementation approaches.

## 2. Primary Key Strategy

Surrogate primary keys were introduced for entities that did not have suitable natural identifiers in the source dataset.

Examples include:

- `subscription_id` in the `subscription` table.
- `plan_id` in the `plan` table.
- `service_id` in the `services` table.

The original `customerID` was retained as the primary key of the `customer` table because it is already a unique identifier in the source dataset.

## 3. Boolean Data Type Mapping

The IBM Telco Customer Churn dataset represents several binary attributes using textual or numeric values.

These attributes were mapped to PostgreSQL BOOLEAN columns.

| Source Attribute | Source Values | PostgreSQL Type |
|---|---|---|
| SeniorCitizen | 0, 1 | BOOLEAN |
| Partner | Yes, No | BOOLEAN |
| Dependents | Yes, No | BOOLEAN |

**Rationale:**

BOOLEAN provides a more appropriate representation for attributes that have only two possible logical states.

This is a data type mapping decision rather than a data-cleaning operation.

## 4. Subscription and Plan Modeling

The source dataset contains three contract types but does not provide a separate plan identifier.

A dedicated `plan` entity was introduced to represent contract types independently.

A surrogate `plan_id` was assigned to each plan, and subscriptions reference their corresponding plan through a foreign key.

**Rationale:**

Separating plans from subscriptions avoids repeating plan definitions across customer records and provides a foundation for extending the plan catalog in the future.

## 5. Many-to-Many Relationship Resolution

Two many-to-many relationships were identified in the conceptual design:

- Plans and services.
- Subscriptions and services.

These relationships were resolved using junction tables:

- `service_plan`
- `subscription_services`

Composite primary keys were selected to prevent duplicate combinations.

**Rationale:**

Junction tables provide a normalized relational structure and allow additional relationship-specific attributes to be stored independently.

For example, `service_plan` includes `is_included` and `is_optional`, while `subscription_services` stores the current service status.

## 6. Customer and Subscription Relationship

The database supports a one-to-many relationship between customers and subscriptions.

A customer may have multiple subscriptions, while each subscription references one customer.

The initial dataset contains one record per customer, so one subscription was created for each source customer during the initial data-loading process.

**Rationale:**

The relational design supports future scenarios in which customers may have multiple subscriptions, even though the initial dataset does not demonstrate that scenario.

## 7. Subscription Service History

A separate `subscription_service_history` table was introduced to support historical tracking of service status changes.

The table includes:

- Previous status.
- New status.
- Change timestamp.
- Change reason.

**Rationale:**

Separating historical events from the current service state prevents historical records from being mixed with the current subscription-service relationship.

The table remains empty in the initial implementation because the source dataset does not contain historical service events.

## 8. Source Data Limitations

The IBM Telco Customer Churn dataset was selected as the initial data source.

It provides customer demographics, subscription tenure, contract types, service subscriptions, billing-related attributes, and churn information.

However, it does not contain actual telecom usage records such as CDRs, network activity logs, or detailed billing transactions.

**Decision:**

The dataset was retained for the initial database design and implementation rather than expanding the project scope to search for a different dataset.

Additional telecom usage and transaction data may be introduced in a separate future project.

## 9. Missing Contract Start Date

The source dataset provides subscription tenure but does not contain an actual contract start date.

The database includes `contract_start_date` as a DATE attribute, but the value is initially NULL during data loading.

**Rationale:**

Generating an artificial contract start date from incomplete information would introduce assumptions that cannot be verified from the source data.

## 10. Initial Plan-Service Mapping

The source dataset does not define formal service eligibility rules for each subscription plan.

For the initial implementation, all nine service definitions were associated with all three plans.

The following initial values were used:

- `is_included = FALSE`
- `is_optional = TRUE`

**Rationale:**

This provides an initial relationship structure for demonstrating the database model.

The mapping is an implementation assumption and should be refined when actual product and service eligibility rules become available.

## 11. Staging-Based Data Loading

A temporary staging table was used to load the original CSV data before inserting records into the normalized target tables.

All staging columns were initially defined as TEXT.

Type conversion was performed during insertion into the target tables.

**Rationale:**

This approach separates source-data ingestion from the normalized database structure and provides greater control over data type mapping.

## 12. Physical Foreign Key Implementation

During physical database generation, pgModeler automatically generated separate foreign key columns for some relationships instead of reusing the manually defined primary key columns in the junction tables.

The generated columns were retained in the initial implementation, and corresponding values were populated consistently.

**Rationale:**

The initial implementation prioritized completing and validating the relational database deployment.

Reviewing and refining these generated columns remains a potential improvement to the physical schema.

## 13. Future Improvements

Potential improvements identified for subsequent development include:

- Refining relationship-generated foreign key columns.
- Implementing a more detailed service status history model.
- Introducing service activation and deactivation event data.
- Adding realistic telecom usage and billing datasets.
- Refining plan-service eligibility rules.
- Expanding data integrity constraints based on additional business rules.

---

**Project:** Telecom Database Design

**Database:** PostgreSQL 16

**Documentation:** Design Decisions
