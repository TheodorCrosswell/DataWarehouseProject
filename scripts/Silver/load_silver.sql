--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script cleans data from the Bronze layer and loads it into the Silver layer of the Data Warehouse Project:
-Silver.CRM_CUSTOMER_INFO
-Silver.CRM_PRODUCT_INFO
-Silver.CRM_SALES_DETAILS
-Silver.ERP_CUSTOMER_INFO
-Silver.ERP_CUSTOMER_COUNTRY
-Silver.ERP_PRODUCT_CATEGORIES
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Make sure that the tables used by this script are created. (execute ddl_bronze.sql)
-Ensure that you are loading the correct data from the correct file location.
--------------------------------------------------------------------------------------------------
*/
TRUNCATE TABLE silver.crm_customer_info;

INSERT INTO silver.crm_customer_info (
	cst_id
	,cst_key
	,cst_firstname
	,cst_lastname
	,cst_marital_status
	,CST_GNDR
	,DWH_CREATE_DATE
	)
SELECT cst_id
	,cst_key
	,Trim(cst_firstname) AS CST__FIRSTNAME
	,Trim(cst_lastname) AS CST_LASTNAME
	,CASE 
		WHEN Upper(Trim(cst_marital_status)) = 'S'
			THEN 'Single'
		WHEN Upper(Trim(cst_marital_status)) = 'M'
			THEN 'Married'
		ELSE 'Unknown'
		END AS CST_MARITAL_STATUS
	,CASE 
		WHEN Upper(Trim(cst_gndr)) = 'M'
			THEN 'Male'
		WHEN Upper(Trim(cst_gndr)) = 'F'
			THEN 'Female'
		ELSE 'Unknown'
		END AS CST_GNDR
	,Getdate() AS DWH_CREATE_DATE
FROM (
	SELECT *
		,Row_number() OVER (
			PARTITION BY cst_id ORDER BY cst_create_date DESC
			) AS duplicate_rank
	FROM bronze.crm_customer_info
	WHERE cst_id IS NOT NULL
	) t
WHERE duplicate_rank = 1;

TRUNCATE TABLE silver.crm_product_info;

INSERT INTO silver.crm_product_info (
	prd_id
	,cat_id
	,prd_key
	,prd_nm
	,prd_cost
	,prd_line
	,prd_start_dt
	,prd_end_dt
	)
SELECT prd_id
	,replace(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id
	,SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key
	,prd_nm
	,isnull(prd_cost, 0) AS prd_cost
	,CASE 
		WHEN upper(trim(prd_line)) = 'M'
			THEN 'Mountain'
		WHEN upper(trim(prd_line)) = 'R'
			THEN 'Road'
		WHEN upper(trim(prd_line)) = 'S'
			THEN 'Others'
		WHEN upper(trim(prd_line)) = 'T'
			THEN 'Touring'
		ELSE 'Unknown'
		END AS prd_line
	,prd_start_dt
	,cast(cast(lead(prd_start_dt) OVER (
				PARTITION BY prd_key ORDER BY prd_start_dt
				) AS DATETIME) - 1 AS DATE) AS prd_end_dt
FROM BRONZE.CRM_PRODUCT_INFO;