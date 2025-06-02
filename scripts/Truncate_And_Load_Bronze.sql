--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script loads data from .csv files into the Bronze layer of the Data Warehouse Project:
-Bronze.CRM_CUSTOMER_INFO
-Bronze.CRM_PRODUCT_INFO
-Bronze.CRM_SALES_DETAILS
-Bronze.ERP_CUSTOMER_INFO
-Bronze.ERP_CUSTOMER_COUNTRY
-Bronze.ERP_PRODUCT_CATEGORIES
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Make sure that the tables used by this script are created. (execute Drop_And_Create_Tables_Bronze.sql)
-Ensure that you are loading the correct data from the correct file location.
--------------------------------------------------------------------------------------------------
*/

--Truncate bronze.crm_customer_info
TRUNCATE TABLE bronze.crm_customer_info;

--Load bronze.crm_customer_info
BULK INSERT bronze.crm_customer_info
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


--Truncate bronze.crm_product_info
TRUNCATE TABLE bronze.crm_product_info;

--Load bronze.crm_product_info
BULK INSERT bronze.crm_product_info
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


--Truncate bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details;

--Load bronze.crm_sales_details
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


--Truncate bronze.erp_customer_info
TRUNCATE TABLE bronze.erp_customer_info;

--Load bronze.erp_customer_info
BULK INSERT bronze.erp_customer_info
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


--Truncate bronze.erp_customer_country
TRUNCATE TABLE bronze.erp_customer_country;

--Load bronze.erp_customer_country
BULK INSERT bronze.erp_customer_country
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


--Truncate bronze.erp_product_categories
TRUNCATE TABLE bronze.erp_product_categories;

--Load bronze.erp_product_categories
BULK INSERT bronze.erp_product_categories
FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
