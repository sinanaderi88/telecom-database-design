# Data Dictionary

## 1. Overview

This document describes the physical structure of the Telecom Database, including table definitions, column descriptions, data types, primary keys, and foreign key relationships.

The database is implemented in PostgreSQL 16 under the `telecom` schema.

## 2. Customer

**Purpose:** Stores customer demographic and household-related information.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| customer_id | VARCHAR(20) | PK, NOT NULL | Unique customer identifier |
| gender | VARCHAR(10) | NULL | Customer gender |
| senior_citizen | BOOLEAN | NULL | Indicates whether the customer is a senior citizen |
| partner | BOOLEAN | NULL | Indicates whether the customer has a partner |
| dependents | BOOLEAN | NULL | Indicates whether the customer has dependents |

## 3. Subscription

**Purpose:** Stores subscription records associated with customers and plans.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| subscription_id | BIGINT | PK, NOT NULL | Unique subscription identifier |
| tenure | INTEGER | NULL | Subscription duration in months |
| contract_start_date | DATE | NULL | Subscription contract start date |
| customer_id_customer | VARCHAR(20) | FK, NULL | References `customer.customer_id` |
| plan_id_plan | BIGINT | FK, NULL | References `plan.plan_id` |

## 4. Plan

**Purpose:** Defines the available subscription plans.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| plan_id | BIGINT | PK, NOT NULL | Unique plan identifier |
| plan_name | VARCHAR(50) | NOT NULL | Plan name |
| contract_type | VARCHAR(30) | NOT NULL | Contract duration or type |
| description | VARCHAR(500) | NULL | Additional plan information |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE | Indicates whether the plan is active |

## 5. Services

**Purpose:** Maintains the catalog of telecom services.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| service_id | BIGINT | PK, NOT NULL | Unique service identifier |
| service_name | VARCHAR(100) | NOT NULL | Service name |
| service_category | VARCHAR(50) | NULL | Service classification |
| description | VARCHAR(500) | NULL | Additional service information |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE | Indicates whether the service is active |

## 6. Service Plan

**Purpose:** Resolves the many-to-many relationship between plans and services and defines service availability within each plan.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| plan_id | BIGINT | PK, NOT NULL | Plan identifier |
| service_id | BIGINT | PK, NOT NULL | Service identifier |
| is_included | BOOLEAN | NOT NULL | Indicates whether the service is included in the plan |
| is_optional | BOOLEAN | NOT NULL | Indicates whether the service is optional |
| service_id_services | BIGINT | FK, NULL | References `services.service_id` |
| plan_id_plan | BIGINT | FK, NULL | References `plan.plan_id` |

**Primary Key:** Composite key consisting of `(plan_id, service_id)`.

## 7. Subscription Services

**Purpose:** Stores the services associated with individual subscriptions and their current status.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| subscription_id | BIGINT | PK, NOT NULL | Subscription identifier |
| service_id | BIGINT | PK, NOT NULL | Service identifier |
| service_status | VARCHAR(20) | NULL | Current service status |
| activation_date | DATE | NULL | Service activation date |
| deactivation_date | DATE | NULL | Service deactivation date |
| subscription_id_subscription | BIGINT | FK, NULL | References `subscription.subscription_id` |
| service_id_services | BIGINT | FK, NULL | References `services.service_id` |

**Primary Key:** Composite key consisting of `(subscription_id, service_id)`.

## 8. Subscription Service History

**Purpose:** Maintains a record of service status changes associated with subscriptions.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| history_id | BIGINT | PK, NOT NULL | Unique history record identifier |
| subscription_id | BIGINT | NULL | Subscription identifier |
| service_id | BIGINT | NULL | Service identifier |
| old_status | VARCHAR(20) | NULL | Previous service status |
| new_status | VARCHAR(20) | NOT NULL | New service status |
| change_date | TIMESTAMP | NOT NULL | Date and time of the status change |
| change_reason | VARCHAR(255) | NULL | Reason for the status change |
| subscription_id_subscription | BIGINT | FK, NULL | References `subscription.subscription_id` |

## 9. Relationship Summary

| Referencing Table | Referenced Table | Relationship |
|---|---|---|
| subscription | customer | Many-to-One |
| subscription | plan | Many-to-One |
| service_plan | plan | Many-to-One |
| service_plan | services | Many-to-One |
| subscription_services | subscription | Many-to-One |
| subscription_services | services | Many-to-One |
| subscription_service_history | subscription | Many-to-One |

## 10. Notes

- Primary keys uniquely identify records within their respective tables.
- Junction tables use composite primary keys to prevent duplicate plan-service and subscription-service combinations.
- Foreign key columns generated by pgModeler are documented using their actual physical names.
- The current implementation retains separate relationship-generated foreign key columns alongside the original composite key columns in the junction tables.
- The `subscription_service_history` table is designed for future historical tracking and is currently empty.
- Nullable attributes reflect the current physical implementation and may be refined as additional business rules are introduced.
