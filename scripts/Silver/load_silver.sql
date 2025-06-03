--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script cleans data from the bronze layer and loads it into the silver layer of the Data Warehouse Project:
-silver.crm_customer_info
-silver.crm_product_info
-silver.crm_sales_details
-silver.erp_customer_info
-silver.erp_customer_country
-silver.erp_product_categories
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Make sure that the tables used by this script are created. (run ddl_bronze.sql)
-Ensure that you are loading the correct data from the correct file location.
--------------------------------------------------------------------------------------------------
*/
--Truncating  silver.crm_customer_info
TRUNCATE TABLE silver.crm_customer_info;

--Loading silver.crm_customer_info
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

--Truncating  silver.crm_product_info
TRUNCATE TABLE silver.crm_product_info;

--Loading silver.crm_product_info
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
FROM bronze.crm_product_info;

--Truncating silver.crm_sales_details
TRUNCATE TABLE silver.crm_sales_details;

--Loading silver.crm_sales_details
INSERT INTO silver.crm_sales_details (
	sls_ord_num
	,sls_prd_key
	,sls_cust_id
	,sls_order_dt
	,sls_ship_dt
	,sls_due_dt
	,sls_sales
	,sls_quantity
	,sls_price
	)
SELECT sls_ord_num
	,sls_prd_key
	,sls_cust_id
	,CASE 
		WHEN sls_order_dt < 0
			OR len(sls_order_dt) != 8
			THEN NULL
		ELSE cast(cast(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt
	,CASE 
		WHEN sls_ship_dt < 0
			OR len(sls_ship_dt) != 8
			THEN NULL
		ELSE cast(cast(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt
	,CASE 
		WHEN sls_due_dt < 0
			OR len(sls_due_dt) != 8
			THEN NULL
		ELSE cast(cast(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt
	,CASE 
		WHEN sls_sales <= 0
			OR sls_sales IS NULL
			OR sls_sales != sls_quantity * abs(sls_price)
			THEN sls_quantity * abs(sls_price)
		ELSE sls_sales
		END AS sls_sales
	,sls_quantity
	,CASE 
		WHEN sls_price = 0
			OR sls_price IS NULL
			THEN sls_sales / nullif(sls_quantity, 0)
		ELSE abs(sls_price)
		END AS sls_price
FROM bronze.crm_sales_details;

--Truncating erp_customer_info
TRUNCATE TABLE silver.erp_customer_info;

--Loading
INSERT INTO silver.erp_customer_info (
	cid
	,bdate
	,gen
	)
SELECT CASE 
		WHEN cid LIKE 'NAS%'
			THEN SUBSTRING(cid, 4, len(cid))
		ELSE cid
		END AS cid
	,CASE 
		WHEN bdate > '1900-01-01'
			AND bdate < GETDATE()
			THEN bdate
		ELSE NULL
		END AS bdate
	,CASE 
		WHEN upper(trim(gen)) = 'M'
			THEN 'Male'
		WHEN upper(trim(gen)) = 'F'
			THEN 'Female'
		WHEN trim(gen) = ''
			THEN 'Unknown'
		ELSE gen
		END AS gen
FROM bronze.erp_customer_info

--Truncating silver.erp_customer_country
TRUNCATE TABLE silver.erp_customer_country;

--Loading silver.erp_customer_country
INSERT INTO silver.erp_customer_country (
	cid
	,cntry
	)
SELECT DISTINCT replace(cid, '-', '')
	,CASE 
		WHEN upper(trim(cntry)) = 'DE'
			THEN 'Germany'
		WHEN upper(trim(cntry)) IN (
				'US'
				,'USA'
				)
			THEN 'United States'
		WHEN trim(cntry) = ''
			OR cntry IS NULL
			THEN 'Unknown'
		ELSE trim(cntry)
		END AS cntry
FROM bronze.erp_customer_country;

--Truncating silver.erp_product_categories
TRUNCATE TABLE silver.erp_product_categories;

--Loading silver.erp_product_categories
INSERT INTO silver.erp_product_categories (
	id
	,cat
	,subcat
	,maintenance
	)
SELECT id
	,cat
	,subcat
	,maintenance
FROM bronze.erp_product_categories