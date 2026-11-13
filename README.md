# Telecom Database Design

## Project Overview

This project focuses on designing and implementing a relational database for a telecommunications customer and subscription management system using PostgreSQL.

The project uses the IBM Telco Customer Churn dataset as its initial data source and transforms its customer, subscription, plan, and service information into a normalized relational database structure.

The primary objective is to demonstrate practical database design skills, including conceptual and logical modeling, physical implementation, relational constraints, data loading, and data validation.

## Project Objectives

- Design a relational database for a telecom domain.
- Identify entities, attributes, and relationships.
- Implement the physical database schema in PostgreSQL.
- Define primary keys, foreign keys, and data types.
- Load source data into relational tables.
- Validate record counts and relationships.
- Document technical decisions and implementation details.

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL 16 | Relational database |
| pgModeler 1.2.3 | Database modeling |
| DBeaver | Database administration |
| Python / Pandas | Dataset inspection and validation |
| Jupyter Notebook | Exploratory data validation |
| Git / GitHub | Version control and project documentation |

## Database Architecture

The database is organized around the following entities:

| Table | Description |
|---|---|
| `customer` | Customer information |
| `subscription` | Customer subscription records |
| `plan` | Subscription contract plans |
| `services` | Available telecom services |
| `service_plan` | Relationship between plans and services |
| `subscription_services` | Services associated with subscriptions |
| `subscription_service_history` | Service status change history |

The design includes one-to-many and many-to-many relationships to represent customer subscriptions, available plans, and subscribed services.

## Repository Structure
```text
telecom-database-design/
├── data/
│   └── raw/
│       ├── Telco-Customer-Churn.csv
│       └── 01_dataset_validation.ipynb
├── docs/
│   ├── 01_project_overview.md
│   ├── 02_database_design.md
│   ├── 03_database_implementation.md
│   ├── 04_data_dictionary.md
│   ├── 05_design_decisions.md
│   └── 06_environment_setup.md
├── sql/
│   └── telecom_database_design.sql
├── .gitignore
└── README.md
```
## Dataset

The project uses the IBM Telco Customer Churn dataset, containing 7,043 customer records.

The dataset includes customer demographics, subscription information, services, contract types, and billing attributes.

**Dataset limitation:** The source dataset does not contain detailed Call Detail Records (CDRs), actual network usage logs, or transaction-level billing data. Therefore, the current database focuses on customer and subscription management rather than detailed telecom usage analytics.

## Implementation and Validation

The database was implemented in PostgreSQL 16.

The initial data loading and validation process produced the following record counts:

| Table | Records |
|---|---:|
| customer | 7,043 |
| subscription | 7,043 |
| plan | 3 |
| services | 9 |
| service_plan | 27 |
| subscription_services | 29,202 |
| subscription_service_history | 0 |

The history table is intentionally empty because the source dataset does not provide historical service status events.

## Documentation

Detailed project documentation is available in the `docs/` directory:

1. **Project Overview** – Project scope and dataset overview.
2. **Database Design** – Conceptual and logical database design.
3. **Database Implementation** – PostgreSQL implementation details.
4. **Data Dictionary** – Table and column definitions.
5. **Design Decisions** – Technical decisions, assumptions, and limitations.
6. **Environment Setup** – Development environment configuration and reproduction guide.
## Scope and Future Improvements

The current project focuses on relational database design and implementation.

Potential future improvements include:

- Adding synthetic telecom usage and CDR data.
- Extending the model with billing and payment transactions.
- Implementing automated data ingestion and transformation.
- Adding historical tracking and advanced analytical queries.

These improvements are outside the scope of the current database design project.

---

**Project Status:** Database design, implementation, initial data loading, validation, and documentation completed.
