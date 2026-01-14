Data Warehouse & Advanced Analytics Project

Welcome to the Data Warehouse & Advanced Analytics Project repository.

This portfolio project demonstrates an end-to-end data engineering and analytics workflow, covering the full lifecycle from data ingestion and modeling to business intelligence and advanced customer analytics. The project showcases industry best practices in data warehousing, analytics, and data-driven decision-making.

📖 Project Overview

This project is structured across three analytical layers:

Data Engineering (SQL Data Warehouse)

Design and implementation of a modern data warehouse using Medallion Architecture (Bronze, Silver, Gold).

Robust ETL pipelines to ingest, clean, and transform data.

Star-schema modeling optimized for analytical queries.

Business Intelligence & Reporting (SQL + Tableau)

SQL-based analytics for KPI reporting.

Tableau dashboards providing high-level visibility into business performance.

Advanced Analytics (Python)

Deep exploratory data analysis beyond dashboards.

Customer analytics including RFM segmentation, Customer Lifetime Value (CLV), Churn & Retention analysis, and Revenue & Customer Value Prioritization.

Actionable insights, recommendations, and visual storytelling.

🧰 Tools & Technologies

SQL Server / MySQL – Data warehousing and transformations

Python – Advanced analytics (pandas, matplotlib)

Tableau – BI dashboards and KPI reporting

Draw.io – Architecture, data flow, and modeling diagrams

🎯 Project Objectives
Data Engineering

Design and build a modern data warehouse to consolidate ERP and CRM sales data.

Ensure high data quality through cleansing and standardization.

Deliver a business-ready Gold layer optimized for analytics.

Business Intelligence

Develop SQL-based analytics for:

Customer behavior

Product performance

Sales trends

Provide dashboards to support data-driven decision-making.

Advanced Analytics (Python)

Extend BI insights with deeper customer-level analysis.

Identify high-value customers and churn risks.

Quantify revenue impact and prioritize retention strategies.

Translate analytics into clear business actions.

🏗️ Data Architecture

The project follows Medallion Architecture:

Bronze Layer

Raw data ingestion from ERP and CRM CSV sources into SQL Server.

Silver Layer

Data cleansing, normalization, and standardization.

Gold Layer

Business-ready star schema designed for reporting and analytics.

📊 Advanced Customer Analytics (Python)

The Python analytics layer builds on the curated Gold data to uncover deeper insights:

RFM Segmentation – Customer behavior classification using Recency, Frequency, and Monetary metrics

Customer Lifetime Value (CLV) – Estimation of long-term customer value

Churn & Retention Analysis – Behavioral churn signals inferred from engagement patterns

Revenue & Customer Value Prioritization – Identification of high-impact segments

Customer Value & Engagement Action Matrix – Actionable retention and growth strategies

All Python notebooks, visuals, and insights are available in the /analytics directory.

📂 Repository Structure
SQL-Data-warehouse-Project/
│
├── datasets/                           # Source datasets (ERP and CRM data)
│
├── docs/                               # Architecture, diagrams, and documentation
│   ├── etl.drawio
│   ├── data_architecture.drawio
│   ├── data_catalog.md
│   ├── data_flow.drawio
│   ├── data_models.drawio
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/
│   ├── silver/
│   ├── gold/
│
├── analytics/                          # Python-based advanced analytics
│   ├── notebooks/
│   ├── images/
│   └── README.md
│
├── tests/                              # Data quality and validation scripts
│
├── README.md                           # Project overview
├── LICENSE                             # License information
├── .gitignore
└── requirements.txt

📌 Key Takeaway

This project demonstrates how SQL-based data engineering, Tableau BI dashboards, and Python-driven advanced analytics can be combined to deliver end-to-end insights — from raw data to strategic business recommendations.

📜 License

This project is licensed under the MIT License.
You are free to use, modify, and share this project with proper attribution.

👤 About Me

Hello! I’m Wisdom Chinemere Mpamugo (also known as Wisdom Analytics), a data analyst passionate about building scalable data solutions and transforming data into actionable insights.

📫 Let’s connect:

LinkedIn: (add your public LinkedIn profile URL here)











