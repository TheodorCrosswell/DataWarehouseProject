/*

Quality Checks

Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.

*/


-- Checking 'gold.dimension_customers'

-- Check for Uniqueness of Customer Key in gold.dimension_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dimension_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- Checking 'gold.product_key'

-- Check for Uniqueness of Product Key in gold.dimension_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dimension_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Checking 'gold.fact_sales'

-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dimension_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dimension_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
