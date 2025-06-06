CREATE
	OR

ALTER VIEW gold.dimension_customers
AS
SELECT row_number() OVER (
		ORDER BY cci.cst_id ASC
		) AS customer_key
	,cci.cst_id AS customer_id
	,cci.cst_key AS customer_number
	,cci.cst_firstname AS customer_firstname
	,cci.cst_lastname AS customer_lastname
	,ecc.cntry AS customer_country
	,CASE 
		WHEN cci.cst_gndr != 'Unknown'
			THEN cci.cst_gndr
		ELSE coalesce(eci.gen, 'Unknown')
		END AS customer_gender
	,cci.cst_marital_status AS customer_marital_status
	,eci.bdate AS customer_birthdate
	,cci.cst_create_date AS customer_create_date
FROM silver.crm_customer_info AS cci
LEFT JOIN silver.erp_customer_info AS eci ON cci.cst_key = eci.cid
LEFT JOIN silver.erp_customer_country AS ecc ON cci.cst_key = ecc.cid;
GO

CREATE
	OR

ALTER VIEW gold.dimension_products
AS
SELECT row_number() OVER (
		ORDER BY cpi.prd_start_dt ASC
		) AS product_key
	,cpi.prd_id AS product_id
	,cpi.prd_key AS product_number
	,cpi.cat_id AS product_category_id
	,epc.cat AS product_category
	,cpi.prd_line AS product_line
	,epc.subcat AS product_subcategory
	,cpi.prd_nm AS product_name
	,epc.maintenance AS product_maintenance
	,cpi.prd_cost AS product_cost
	,cpi.prd_start_dt AS product_start_date
FROM silver.crm_product_info AS cpi
LEFT JOIN silver.erp_product_categories AS epc ON cpi.cat_id = epc.id
WHERE cpi.prd_end_dt IS NULL;
GO

CREATE
	OR

ALTER VIEW gold.fact_sales
AS
SELECT csd.sls_ord_num AS sales_order_number
	,dp.product_number AS product_number
	,dc.customer_id AS customer_id
	,csd.sls_order_dt AS sales_order_date
	,csd.sls_ship_dt AS sales_ship_date
	,csd.sls_due_dt AS sales_due_date
	,csd.sls_sales AS sales_sales
	,csd.sls_quantity AS sales_quantity
	,csd.sls_price AS sales_price
FROM silver.crm_sales_details AS csd
LEFT JOIN gold.dimension_customers AS dc ON csd.sls_cust_id = dc.customer_id
LEFT JOIN gold.dimension_products AS dp ON csd.sls_prd_key = dp.product_number;