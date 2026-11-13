# Telecom Database Design

## 1. Project Overview

This project focuses on designing and implementing a relational database for a telecommunications company using PostgreSQL.

The goal is to build a structured database that manages customers, subscriptions, service plans, and the services associated with each subscription.

## 2. Project Scenario

We assume a telecommunications company needs a centralized database to organize information about its customers and their subscriptions.

The database design will cover the following main entities:

- Customers
- Subscriptions
- Plans
- Services
- Plan-Service relationships
- Subscription-Service relationships
- Subscription-Service status history

The design aims to maintain data consistency, referential integrity, and support future analytical requirements.

## 3. Dataset Source

The initial reference dataset is the publicly available IBM Telco Customer Churn dataset.

Dataset characteristics:

- Number of records: 7,043
- Number of columns: 21
- Format: CSV

The dataset includes customer information, subscription details, service selections, contract types, and billing-related attributes.

**Note:** This dataset does not contain actual Call Detail Records (CDRs), network usage logs, or detailed telecom transactions. It is used as a reference dataset for the initial database design.

## 4. Initial Dataset Validation

The dataset was loaded and examined using Python and Pandas.

The following validation activities were performed:

1. Dataset structure and initial inspection
2. Data integrity and value validation
3. Investigation of blank `TotalCharges` records
4. Service subscription distribution analysis
5. Contract, payment method, and numerical statistics

Key findings:

- 7,043 customer records were identified.
- No duplicate customer IDs were found.
- Eleven records contained blank `TotalCharges` values.
- All eleven records with blank `TotalCharges` had a `tenure` value of zero.

These records were investigated and retained without modification during the initial validation stage.

## 5. Technology Stack

- PostgreSQL 16
- Python
- Pandas
- Jupyter Notebook
- DBeaver Community Edition
- Git and GitHub

## 6. Project Scope

The current project includes:

1. Conceptual database design
2. Entity Relationship Diagram (ERD)
3. Logical database design
4. Physical database implementation using PostgreSQL
5. Primary keys, foreign keys, and integrity constraints
6. Database documentation and data dictionary

Data cleaning and automated ETL pipelines using Apache Airflow are outside the scope of this project and will be considered separately.

## 7. Repository Structure

```text
telecom-database-design/
├── data/
│   └── raw/
├── docs/
│   └── 01_project_overview.md
├── notebooks/
│   └── 01_dataset_validation.ipynb
└── README.md
```
