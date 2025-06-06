--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script drops and then creates the tables used by silver layer of the Data Warehouse Project:
-silver.crm_customer_info
-silver.crm_product_info
-silver.crm_sales_details
-silver.erp_customer_info
-silver.erp_customer_country
-silver.erp_product_categories
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Create the silver Schema (CREATE SCHEMA silver;)
-Ensure that you do not have tables with the same name that you do not want to lose,
 as they will be dropped and recreated when this script is executed.
--------------------------------------------------------------------------------------------------
*/
--Create Schema silver
--Create CRM Customer Info Table
IF Object_id('silver.crm_customer_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_customer_info;

CREATE TABLE silver.crm_customer_info (
	cst_id INT
	,cst_key NVARCHAR(50)
	,cst_firstname NVARCHAR(50)
	,cst_lastname NVARCHAR(50)
	,cst_marital_status NVARCHAR(50)
	,cst_gndr NVARCHAR(10)
	,cst_create_date DATE
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);

--Create CRM Product Info Table
IF Object_id('silver.crm_product_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_product_info;

CREATE TABLE silver.crm_product_info (
	prd_id INT
	,cat_id NVARCHAR(10)
	,prd_key NVARCHAR(50)
	,prd_nm NVARCHAR(50)
	,prd_cost INT
	,prd_line NVARCHAR(10)
	,prd_start_dt DATE
	,prd_end_dt DATE
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);

--Create CRM Sales Details Table
IF Object_id('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50)
	,sls_prd_key NVARCHAR(50)
	,sls_cust_id INT
	,sls_order_dt DATE
	,sls_ship_dt DATE
	,sls_due_dt DATE
	,sls_sales INT
	,sls_quantity INT
	,sls_price INT
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);

--Create ERP Customer Info Table
IF Object_id('silver.erp_customer_info ', 'U') IS NOT NULL
	DROP TABLE silver.erp_customer_info;

CREATE TABLE silver.erp_customer_info (
	cid NVARCHAR(50)
	,bdate DATE
	,gen NVARCHAR(10)
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);

--Create ERP Customer Country Table
IF Object_id('silver.erp_customer_country', 'U') IS NOT NULL
	DROP TABLE silver.erp_customer_country;

CREATE TABLE silver.erp_customer_country (
	cid NVARCHAR(50)
	,cntry NVARCHAR(50)
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);

--Create ERP Product Categories Table
IF Object_id('silver.erp_product_categories', 'U') IS NOT NULL
	DROP TABLE silver.erp_product_categories;

CREATE TABLE silver.erp_product_categories (
	id NVARCHAR(10)
	,cat NVARCHAR(50)
	,subcat NVARCHAR(50)
	,maintenance NVARCHAR(10)
	,dwh_create_date DATETIME2 DEFAULT getdate()
	);