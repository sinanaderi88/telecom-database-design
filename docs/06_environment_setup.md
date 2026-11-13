# 06 - Environment Setup and Reproduction Guide

This document describes the development environment and the main steps required to recreate the database environment for the Telecom Database Design project.

## 1. Development Environment

The project was developed and tested in the following environment:

| Component | Version / Description |
|---|---|
| Operating System | Ubuntu 24.04.4 LTS |
| Virtualization | Oracle VirtualBox |
| Database | PostgreSQL 16 |
| Database Modeling | pgModeler 1.2.3 |
| Database Client | DBeaver Community Edition |
| Programming Language | Python 3.12 |
| Data Analysis | Pandas |
| Notebook Environment | Jupyter Notebook |
| Version Control | Git |

## 2. Project Directory

The project is organized as follows:

```text
telecom-database-design/
├── data/
│   └── raw/
│       ├── Telco-Customer-Churn.csv
│       └── 01_dataset_validation.ipynb
├── docs/
├── sql/
│   └── telecom_database_design.sql
├── .gitignore
└── README.md
```

## 3. PostgreSQL Configuration

The database was created using PostgreSQL 16.

The following database objects were configured:

- Database: `telecom_db`
- Database role: `telecom_user`
- Schema: `telecom`

The database role was assigned ownership of the project database and schema.

### Initial Database Setup

Connect to PostgreSQL using an administrative account and create the project role:

```sql
CREATE ROLE telecom_user WITH LOGIN PASSWORD 'YOUR_PASSWORD';
```

Create the database:

```sql
CREATE DATABASE telecom_db OWNER telecom_user;
```

Connect to `telecom_db` and create the project schema:

```sql
CREATE SCHEMA telecom AUTHORIZATION telecom_user;
```

Configure the default schema search path:

```sql
ALTER ROLE telecom_user IN DATABASE telecom_db
SET search_path TO telecom, public;
```

Replace `YOUR_PASSWORD` with a secure password. Do not store database passwords in the project repository.

## 4. Database Model and SQL Implementation

The database model was designed using pgModeler 1.2.3.

The physical database structure was generated and exported as a PostgreSQL SQL script.

Main implementation file:

```text
sql/telecom_database_design.sql
```

To create the database objects, execute the SQL script from the project root directory:

```bash
psql -h localhost -U telecom_user -d telecom_db -W -f sql/telecom_database_design.sql
```

The script creates the project tables, primary keys, foreign keys, and other defined database objects.

## 5. Database Connection Using DBeaver

DBeaver Community Edition was used to connect to and inspect the PostgreSQL database.

Connection parameters:

| Parameter | Value |
|---|---|
| Database Type | PostgreSQL |
| Host | localhost |
| Port | 5432 |
| Database | telecom_db |
| Username | telecom_user |
| Password | Configured during role creation |

After connecting, the `telecom` schema can be inspected to review the implemented tables and relationships.

## 6. Dataset Validation

The source dataset is the IBM Telco Customer Churn sample dataset:

```text
data/raw/Telco-Customer-Churn.csv
```

Initial dataset inspection and validation were performed using the Jupyter Notebook:

```text
data/raw/01_dataset_validation.ipynb
```

The notebook covers dataset structure, data integrity, missing values, service distribution, and basic statistical analysis.

## 7. Data Loading Overview

The source CSV data was loaded into PostgreSQL through a staging table.

The general loading workflow was:

1. Create a temporary staging table.
2. Import the CSV data using PostgreSQL `\copy`.
3. Transform source values into the target database data types.
4. Insert records into the normalized project tables.
5. Validate record counts and relationships.

The schema definition
The schema definition is available in `sql/telecom_database_design.sql`.

**Note:** The current SQL script contains the database structure definition. The data-loading workflow was performed separately during implementation and is not yet packaged as a fully automated loading script.

## 8. Validation Results

After implementation and data loading, the following checks were performed:

- Record counts were checked across all seven project tables.
- Orphan records were checked in relationship tables.
- Service subscription counts were compared against the source dataset.

The validation results matched the expected source data counts, and all six orphan-record checks returned zero records.

## 9. Reproducibility Notes

To recreate the database environment:

1. Install the required database software.
2. Create the PostgreSQL role, database, and schema.
3. Execute the database SQL script.
4. Load the source dataset using the documented staging workflow.
5. Run the validation queries.

Some environment-specific installation steps may vary depending on the operating system and software package sources.
