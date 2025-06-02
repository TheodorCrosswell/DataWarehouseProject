--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script drops and then creates the tables used by Bronze layer of the Data Warehouse Project:
-Bronze.CRM_CUSTOMER_INFO
-Bronze.CRM_PRODUCT_INFO
-Bronze.CRM_SALES_DETAILS
-Bronze.ERP_CUSTOMER_INFO
-Bronze.ERP_CUSTOMER_COUNTRY
-Bronze.ERP_PRODUCT_CATEGORIES
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Create the Bronze Schema (CREATE SCHEMA Bronze;)
-Ensure that you do not have tables with the same name that you do not want to lose,
 as they will be dropped and recreated when this script is executed.
--------------------------------------------------------------------------------------------------
*/
--Create Schema Bronze
--Create CRM Customer Info Table
IF Object_id('bronze.crm_customer_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_customer_info;

CREATE TABLE bronze.crm_customer_info (
	cst_id INT
	,cst_key NVARCHAR(50)
	,cst_firstname NVARCHAR(50)
	,cst_lastname NVARCHAR(50)
	,cst_marital_status NVARCHAR(50)
	,cst_gndr NVARCHAR(10)
	,cst_create_date DATE
	);

--Create CRM Product Info Table
IF Object_id('BRONZE.CRM_PRODUCT_INFO', 'U') IS NOT NULL
	DROP TABLE bronze.crm_product_info;

CREATE TABLE bronze.crm_product_info (
	prd_id INT
	,prd_key NVARCHAR(50)
	,prd_nm NVARCHAR(50)
	,prd_cost INT
	,prd_line NVARCHAR(10)
	,prd_start_dt DATE
	,prd_end_dt DATE
	);

--Create CRM Sales Details Table
IF Object_id('BRONZE.CRM_SALES_DETAILS', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50)
	,sls_prd_key NVARCHAR(50)
	,sls_cust_id INT
	,sls_order_dt INT
	,sls_ship_dt INT
	,sls_due_dt INT
	,sls_sales INT
	,sls_quantity INT
	,sls_price INT
	);

--Create ERP Customer Info Table
IF Object_id('BRONZE.ERP_CUSTOMER_INFO ', 'U') IS NOT NULL
	DROP TABLE bronze.erp_customer_info;

CREATE TABLE bronze.erp_customer_info (
	cid NVARCHAR(50)
	,bdate DATE
	,gen NVARCHAR(10)
	);

--Create ERP Customer Country Table
IF Object_id('BRONZE.ERP_CUSTOMER_COUNTRY', 'U') IS NOT NULL
	DROP TABLE bronze.erp_customer_country;

CREATE TABLE bronze.erp_customer_country (
	cid NVARCHAR(50)
	,cntry NVARCHAR(50)
	);

--Create ERP Product Categories Table
IF Object_id('BRONZE.ERP_PRODUCT_CATEGORIES', 'U') IS NOT NULL
	DROP TABLE bronze.erp_product_categories;

CREATE TABLE bronze.erp_product_categories (
	id NVARCHAR(10)
	,cat NVARCHAR(50)
	,subcat NVARCHAR(50)
	,maintenance NVARCHAR(10)
	);