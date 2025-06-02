--MSSQL
/*
--------------------------------------------------------------------------------------------------
This script creates a stored procedure that loads data from .csv files into the Bronze layer of the Data Warehouse Project:
-Bronze.CRM_CUSTOMER_INFO
-Bronze.CRM_PRODUCT_INFO
-Bronze.CRM_SALES_DETAILS
-Bronze.ERP_CUSTOMER_INFO
-Bronze.ERP_CUSTOMER_COUNTRY
-Bronze.ERP_CUSTOMER_CATEGORIES
--------------------------------------------------------------------------------------------------
To run this script:
-Make sure you are using the correct database (USE DataWarehouseProject;)
-Make sure that the tables used by this script are created. (execute Drop_And_Create_Tables_Bronze.sql)
-Ensure that you are loading the correct data from the correct file location.
--------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time datetime, @end_time datetime, @total_start_time datetime, @total_end_time datetime;
	BEGIN TRY
		
		SET @total_start_time = GETDATE();
		PRINT 'Truncating and loading bronze layer';

		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.crm_customer_info';
		--Truncate bronze.crm_customer_info
		TRUNCATE TABLE bronze.crm_customer_info;

		PRINT 'Loading bronze.crm_customer_info';
		--Load bronze.crm_customer_info
		BULK INSERT bronze.crm_customer_info
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.crm_product_info';
		--Truncate bronze.crm_product_info
		TRUNCATE TABLE bronze.crm_product_info;

		PRINT 'Loading bronze.crm_product_info';
		--Load bronze.crm_product_info
		BULK INSERT bronze.crm_product_info
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.crm_sales_details';
		--Truncate bronze.crm_sales_details
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT 'Loading bronze.crm_sales_details';
		--Load bronze.crm_sales_details
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.erp_customer_info';
		--Truncate bronze.erp_customer_info
		TRUNCATE TABLE bronze.erp_customer_info;

		PRINT 'Loading bronze.erp_customer_info';
		--Load bronze.erp_customer_info
		BULK INSERT bronze.erp_customer_info
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.erp_customer_country';
		--Truncate bronze.erp_customer_country
		TRUNCATE TABLE bronze.erp_customer_country;

		PRINT 'Loading bronze.erp_customer_country';
		--Load bronze.erp_customer_country
		BULK INSERT bronze.erp_customer_country
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Truncating bronze.erp_product_categories';
		--Truncate bronze.erp_product_categories
		TRUNCATE TABLE bronze.erp_product_categories;

		PRINT 'Loading bronze.erp_product_categories';
		--Load bronze.erp_product_categories
		BULK INSERT bronze.erp_product_categories
		FROM 'C:\Users\theod\Documents\DataWarehouseProject\Start\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		SET @total_end_time = GETDATE();

		PRINT 'Truncate and load duration: ' + CAST (DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT 'Total truncate and load duration: ' + CAST (DATEDIFF(second, @total_start_time, @total_end_time) as NVARCHAR) + ' seconds';

		PRINT '---------------------------------------------------------------------------------------';

	END TRY

	BEGIN CATCH
		PRINT '---------------------------------------------------------------------------------------';
		PRINT 'Error occoured while loading bronze layer:';
		PRINT 'Error message:' + ERROR_MESSAGE();
		PRINT 'Error number:' + CAST (ERROR_NUMBER() as NVARCHAR);
		PRINT 'Error state:' + CAST (ERROR_STATE() as NVARCHAR);
		PRINT '---------------------------------------------------------------------------------------';
	END CATCH
END;