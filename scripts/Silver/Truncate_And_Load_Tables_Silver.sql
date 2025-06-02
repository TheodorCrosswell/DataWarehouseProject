WITH ranked_duplicates
     AS (SELECT *,
                Row_number()
                  OVER(
                    partition BY cst_id
                    ORDER BY cst_create_date DESC) AS duplicate_rank
         FROM   bronze.crm_customer_info
         WHERE  cst_id IS NOT NULL)
SELECT cst_id,
       cst_key,
       Trim(cst_firstname) AS CST__FIRSTNAME,
       Trim(cst_lastname)  AS CST_LASTNAME,
       CASE
         WHEN Upper(Trim(cst_marital_status)) = 'S' THEN 'Single'
         WHEN Upper(Trim(cst_marital_status)) = 'M' THEN 'Married'
         ELSE 'Unknown'
       END                 AS CST_MARITAL_STATUS,
       CASE
         WHEN Upper(Trim(cst_gndr)) = 'M' THEN 'Male'
         WHEN Upper(Trim(cst_gndr)) = 'F' THEN 'Female'
         ELSE 'Unknown'
       END                 AS CST_GNDR,
       Getdate()           AS DWH_CREATE_DATE
FROM   ranked_duplicates
WHERE  duplicate_rank = 1; 