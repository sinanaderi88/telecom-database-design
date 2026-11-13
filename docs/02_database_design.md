# 02 - Database Design

## 1. Project Overview

This document presents the conceptual and logical database design of the Telecom Database Design project.

The objective is to design and implement a relational database for a simplified telecommunications system using PostgreSQL.

The database model represents the core entities involved in customer management, subscription management, service provisioning, and service lifecycle tracking.

The design process focuses on identifying entities, defining their attributes, establishing relationships, determining relationship cardinalities, and maintaining data integrity through primary and foreign key constraints.

The initial database model was designed using **pgModeler 1.2.3**.

## 2. Conceptual Database Design

### 2.1 Entity Identification

Based on the project scope and the available telecommunications dataset, seven core entities were identified.

| Entity | Description |
|---|---|
| Customer | Stores customer demographic and profile information. |
| Subscription | Represents a customer's subscription to a telecommunications plan. |
| Plan | Defines the subscription plans offered by the provider. |
| Services | Stores the individual services offered by the provider. |
| Service_Plan | Defines which services are associated with each subscription plan. |
| Subscription_Services | Represents the services assigned to individual subscriptions. |
| Subscription_Service_History | Maintains the history of service status changes. |

### 2.2 Entity Relationships and Cardinality

The following relationships were defined as part of the conceptual model.

**Customer – Subscription**

- Cardinality: One-to-Many (1:N).
- A customer can have multiple subscriptions.
- Each subscription belongs to one customer.

This structure supports customers who maintain multiple subscriptions independently.

**Plan – Subscription**

- Cardinality: One-to-Many (1:N).
- A plan can be associated with multiple subscriptions.
- Each subscription is associated with one plan in the current design.

**Plan – Services**

- Cardinality: Many-to-Many (M:N).
- A plan can include multiple services.
- A service can be available in multiple plans.

This relationship is implemented through the `service_plan` junction table.

**Subscription – Services**

- Cardinality: Many-to-Many (M:N).
- A subscription can have multiple services.
- A service can be assigned to multiple subscriptions.

This relationship is implemented through the `subscription_services` junction table.

**Subscription_Services – Subscription_Service_History**

- Cardinality: One-to-Many (1:N).
- A subscription-service assignment can have multiple historical status changes.
- Each history record is intended to refer to a specific subscription-service assignment.

## 3. Logical Database Design

The logical design translates the conceptual model into relational tables by defining attributes, data types, primary keys, and foreign key requirements.

### 3.1 Customer

The `customer` table stores customer profile information.

| Column | Data Type | Constraint |
|---|---|---|
| customer_id | VARCHAR(20) | Primary Key |
| gender | VARCHAR(10) | |
| senior_citizen | BOOLEAN | |
| partner | BOOLEAN | |
| dependents | BOOLEAN | |

**Design decisions:**

- `customer_id` is used as the primary key to uniquely identify each customer.
- The `SeniorCitizen` attribute from the original IBM dataset contains binary values (0 and 1). It is mapped to PostgreSQL BOOLEAN values (FALSE and TRUE), reflecting its binary meaning.

### 3.2 Subscription

The `subscription` table represents the relationship between a customer and a selected subscription plan.

| Column | Data Type | Constraint |
|---|---|---|
| subscription_id | BIGINT | Primary Key |
| customer_id | VARCHAR(20) | Foreign Key |
| plan_id | BIGINT | Foreign Key |
| tenure | INTEGER | |
| contract_start_date | DATE | |

**Design decisions:**

A separate `subscription_id` was introduced as a surrogate primary key.

This design separates subscription records from customer records and allows a customer to maintain multiple subscriptions.

Each subscription references one customer and one plan.

### 3.3 Plan

The `plan` table stores the subscription plans offered by the telecommunications provider.

| Column | Data Type | Constraint |
|---|---|---|
| plan_id | BIGINT | Primary Key |
| plan_name | VARCHAR(50) | |
| contract_type | VARCHAR(30) | |
| description | VARCHAR(500) | |
| is_active | BOOLEAN | |

**Design decisions:**

- `plan_id` is used as a surrogate primary key.
- `is_active` indicates whether a plan is currently available.
- Plan information is maintained independently of individual subscriptions.

### 3.4 Services

The `services` table stores the individual services offered by the provider.

| Column | Data Type | Constraint |
|---|---|---|
| service_id | BIGINT | Primary Key |
| service_name | VARCHAR(100) | |
| service_category | VARCHAR(50) | |
| description | VARCHAR(500) | |
| is_active | BOOLEAN | |

**Design decisions:**

The service catalog is maintained independently of subscription plans and customer subscriptions.

This allows services to be reused across multiple plans and subscriptions without duplicating service definitions.

### 3.5 Service_Plan

The `service_plan` table resolves the many-to-many relationship between plans and services.

| Column | Data Type | Constraint |
|---|---|---|
| plan_id | BIGINT | Composite Primary Key / Foreign Key |
| service_id | BIGINT | Composite Primary Key / Foreign Key |
| is_included | BOOLEAN | |
| is_optional | BOOLEAN | |

**Design decisions:**

A composite primary key consisting of `plan_id` and `service_id` ensures that the same service cannot be associated with the same plan more than once.

The two attributes reference the following parent tables:

- `plan_id` references `plan(plan_id)`.
- `service_id` references `services(service_id)`.

The `is_included` attribute indicates whether a service is included in the plan, while `is_optional` indicates whether the service is optional.

### 3.6 Subscription_Services

The `subscription_services` table resolves the many-to-many relationship between subscriptions and services.

| Column | Data Type | Constraint |
|---|---|---|
| subscription_id | BIGINT | Composite Primary Key / Foreign Key |
| service_id | BIGINT | Composite Primary Key / Foreign Key |
| service_status | VARCHAR(20) | |
| activation_date | DATE | |
| deactivation_date | DATE | |

**Design decisions:**

A composite primary key consisting of `subscription_id` and `service_id` uniquely identifies each service assignment within a subscription.

The table stores the actual services assigned to subscriptions, independently of the services defined as available in a plan.

The `service_status` attribute represents the current status of a service assignment.

The activation and deactivation dates provide basic lifecycle tracking.

### 3.7 Subscription_Service_History

The `subscription_service_history` table is designed to maintain historical records of changes in service status.

| Column | Data Type | Constraint |
|---|---|---|
| history_id | BIGINT | Primary Key |
| subscription_id | BIGINT | Foreign Key (current model) |
| service_id | BIGINT | To be included in the composite foreign key |
| old_status | VARCHAR(20) | |
| new_status | VARCHAR(20) | |
| change_date | TIMESTAMP | |
| change_reason | VARCHAR(255) | |

**Design decisions:**

- `history_id` is used as a surrogate primary key.
- `old_status` and `new_status` capture the status transition.
- `change_date` records when the change occurred.
- `change_reason` provides additional context about the change.

The history table is designed to store status changes rather than duplicate the current status maintained in `subscription_services`.

For referential integrity, the intended final relationship is a composite foreign key:

`(subscription_id, service_id)` references `subscription_services(subscription_id, service_id)`.

This ensures that each historical record belongs to an existing subscription-service assignment.

## 4. Primary Key Strategy

The database design uses single-column primary keys for the main entities and composite primary keys for junction tables.

| Table | Primary Key |
|---|---|
| customer | customer_id |
| subscription | subscription_id |
| plan | plan_id |
| services | service_id |
| service_plan | plan_id + service_id |
| subscription_services | subscription_id + service_id |
| subscription_service_history | history_id |

This approach provides unique identification for individual entities and prevents duplicate associations in junction tables.

## 5. Normalization and Design Considerations

The database model separates customers, subscriptions, plans, and services into independent entities.

Many-to-many relationships are resolved through dedicated junction tables.

This structure was selected to:

- Reduce unnecessary data duplication.
- Improve data consistency.
- Maintain referential integrity.
- Separate service definitions from service assignments.
- Distinguish between current service status and historical status changes.
- Support future extensions to subscription and service management.

In the current version, each subscription is associated with one plan.

## 6. Design Implementation Status

The initial conceptual and logical database model has been created in pgModeler.

The following design activities have been completed:

- Identification of seven core entities.
- Definition of entity attributes.
- Selection of primary keys.
- Definition of relationship cardinalities.
- Resolution of many-to-many relationships through junction tables.
- Initial creation of foreign key relationships.
- Creation of the graphical database model.

During model construction, pgModeler automatically generated foreign key columns for some relationships. This resulted in additional columns alongside the manually defined composite primary key columns in the `service_plan` and `subscription_services` tables.

These generated columns will be reviewed during SQL generation and physical implementation to ensure that the final database schema contains the intended relationships without redundant attributes.

The composite foreign key between `subscription_service_history` and `subscription_services` also remains to be finalized.

## 7. Next Development Steps

The next development activities are:

1. Review and finalize the logical database model.
2. Generate PostgreSQL DDL scripts using pgModeler.
3. Review generated SQL statements and constraints.
4. Implement the database objects in PostgreSQL.
5. Load the source dataset into the appropriate tables.
6. Validate data integrity and relationships.
7. Complete the database documentation and data dictionary.
