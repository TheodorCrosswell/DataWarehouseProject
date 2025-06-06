## Overview
This project is designed to structure, store, and query data in the form of a Data Warehouse using **MSSQL**.

## Features
- **Layered Architecture**: Bronze, Silver, and Gold tables ensure **progressive data refinement**.
- **Optimized Schema**: Fact tables and dimensions **integrate** seamlessly to support analytical queries.
- **Stored Procedures & Functions**: Automate data transformations and table relationships.
- **Exception Handling & Debugging**: Improved error handling for query integrity.
- **Performance Monitoring**: Records query duration in order to highlight any issues.

## Table Integration
The project follows a structured pipeline:
1. **Bronze Layer (Raw Data)**
   - Stores unprocessed data.
   - Acts as the staging area before transformation.

2. **Silver Layer (Cleaned & Enriched Data)**
   - Integrates multiple sources.
   - Applies deduplication, filtering, and enrichment logic.

3. **Gold Layer (Optimized for Analytics)**
   - Joins fact and dimension tables for efficient querying.
   - Enables deep analysis and reporting.

### **Key Table Relationships**
- **Fact Tables** connect with **Dimension Tables** via **foreign keys** for structured reporting.
- **Stored Procedures** facilitate **data movement** across layers.

## Technologies Used
- **Database**: MS SQL Server Express
- **Query Language**: MS SQL
- **ETL Processing**: Bulk data loading & transformations

## Installation

1. Create a database
2. Run query ddl_bronze.sql
3. Run query proc_load_bronze.sql
4. Execute procedure bronze.load_bronze
5. Run query ddl_silver.sql
6. Run query proc_load_silver.sql
7. Execute procedure silver.load_silver
8. Run query create_views_gold.sql

## Prerequisites:
- SQL Server Instance: You need an operational Microsoft SQL Server instance where you can create databases and run queries.
- SQL Server Management Studio (SSMS) or Azure Data Studio: These are graphical tools that allow you to connect to your SQL Server instance, execute queries, and manage databases.

## Step-by-Step Installation:

**1. Create a database**

How to do it:
Open SSMS or Azure Data Studio and connect to your SQL Server instance.
Right-click on "Databases" in the Object Explorer.
Select "New Database...".
Enter a meaningful name for your data warehouse database (e.g., MyDataWarehouse, AdventureWorksDW).
Click "OK".

Explanation: This creates the container for all your data warehouse objects (tables, procedures, views).

**2. Create Bronze, Silver, & Gold Schemas**

How to do it:
Open a new query window in SSMS or Azure Data Studio.
Ensure the active database is the one you just created (e.g., USE MyDataWarehouse;).
Execute the following SQL statements:
- CREATE SCHEMA Bronze;
- CREATE SCHEMA Silver;
- CREATE SCHEMA Gold;

Explanation: Schemas in SQL Server are logical containers for database objects. By creating Bronze, Silver, and Gold schemas, you're organizing your data warehouse layers. This provides several benefits:
- Organization: Clearly separates objects belonging to each data layer.
- Security: You can grant specific permissions at the schema level, controlling who can access or modify objects within each layer (e.g., only ETL processes can write to Bronze, but reporting tools can only read from Gold).

**3. Run query ddl_bronze.sql**

How to do it:
Open the ddl_bronze.sql file in SSMS or Azure Data Studio.
Ensure the active database in the query editor is the one you just created (you can use USE YourDatabaseName; at the beginning of the script or select it from the dropdown).
Execute the script.

Explanation: ddl_bronze.sql contains Data Definition Language (DDL) statements. This script will create the tables. The Bronze layer typically holds raw, unprocessed data directly from your source files.

**4. Run query proc_load_bronze.sql**

How to do it:
Open the proc_load_bronze.sql file.
Ensure the active database is your data warehouse database.
Execute the script.

Explanation: This script defines a stored procedure (e.g., bronze.load_bronze) responsible for loading your raw data files into the Bronze tables. This procedure contains logic to read from specific file paths and insert data. Before running this, you need to inspect proc_load_bronze.sql to understand where it expects your data files to be located and adjust the file locations or the specified file path in the query.

**5. Execute procedure bronze.load_bronze**

How to do it:
Open a new query window in SSMS/Azure Data Studio.
Ensure the active database is your data warehouse database.
Execute the procedure using the EXEC command:
- EXEC bronze.load_bronze;

Explanation: This step actively loads your raw data from the specified data files into the Bronze tables you created in step 2. This is the first data ingestion point.

**6. Run query ddl_silver.sql**

How to do it:
Open the ddl_silver.sql file.
Ensure the active database is your data warehouse database.
Execute the script.

Explanation: ddl_silver.sql contains DDL statements for your Silver layer. This script will create the tables. The Silver layer involves cleaning, transforming, and integrating data from the Bronze layer.

**7. Run query proc_load_silver.sql**

How to do it:
Open the proc_load_silver.sql file.
Ensure the active database is your data warehouse database.
Execute the script.

Explanation: This script defines a stored procedure (silver.load_silver) responsible for processing data from the Bronze layer and loading it into the Silver tables. This procedure contains SQL logic for data cleansing.

**8. Execute procedure silver.load_silver**

How to do it:
Open a new query window.
Ensure the active database is your data warehouse database.
Execute the procedure:
- EXEC silver.load_silver;

Explanation: This step processes the raw data from your Bronze tables, applies the transformations defined in proc_load_silver.sql, and populates your Silver tables. This is where the data starts to become more structured and refined.

**9. Run query create_views_gold.sql**

How to do it:
Open the create_views_gold.sql file.
Ensure the active database is your data warehouse database.
Execute the script.

Explanation: This script creates views for your Gold layer. The Gold layer is designed for reporting and analytical purposes. Instead of creating new tables, it often uses views to present a simplified, aggregated, and highly performant view of the data from the Silver layer. These views are optimized for end-user consumption by business intelligence tools and reports.

## After the Installation:

Verify Data: Query your Bronze, Silver, and Gold tables/views to ensure data has been loaded and transformed correctly.

Reporting and Analysis: You can now connect your business intelligence tools (e.g., Power BI, Tableau, Excel) to your SQL Server database and build reports and dashboards using the Gold views.

Scheduling: For ongoing data updates, you can schedule the execution of bronze.load_bronze and silver.load_silver procedures using SQL Server Agent jobs or other orchestration tools.

By following these steps, you will successfully set up your MSSQL data warehouse and prepare your data for reporting and analysis.
