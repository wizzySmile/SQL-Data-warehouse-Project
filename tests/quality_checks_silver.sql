/*
==================================================================
Quality Checks
==================================================================
Script Purpose:
  This script performs various quality checks for data consistency,
  accuracy and standardization across the 'silver' schemas. It 
  includes checks for:
  - Null or  duplicate primary keys.
  - Unwanted spaces in string fields.
  - Invalid date ranges and orders.
  - Data consistency between related fields.

Usage Notes:
  - Run these checks after data loading silver layer.
  - investigate and resolve any discrepancies found during the 
    checks.
==================================================================
*/

-- ================================================
-- Checking 'silver.crm_cust_info' 
-- ================================================

-- Check for nulls or duplicate in the primary key
-- Expectation: no results
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info 
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces
-- Expectation: no results
SELECT cst_firstname, TRIM(cst_firstname)
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data standardization & consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;



-- ================================================
-- Checking 'silver.crm_prd_info' 
-- ================================================

  -- Checking for duplicates
  -- Expectation: No results
  SELECT prd_id, COUNT(*)
  FROM silver.crm_prd_info
  GROUP BY prd_id
  HAVING COUNT(*) > 1;

  -- Checking for unwanted spaces
  -- Expectation: no result
  SELECT prd_nm 
  FROM silver.crm_prd_info
  WHERE prd_nm != TRIM(prd_nm);

  -- Checking for nulls or negative numbers
  -- Expectation: no result
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Data standardization and consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info 

-- Check for invalid date order
-- Expectation: No result
SELECT *
FROM silver.crm_prd_info 
WHERE prd_start_dt > prd_end_dt



-- ================================================
-- Checking 'silver.crm_sales_details' 
-- ================================================

-- Check for invalid dates
SELECT NULLIF(sls_order_dt,0)sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt <19000101;

-- Check for invalid dates
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt;

-- Check data consistency; Between sales, quantity and price
-- >> Sales = Quantity * Price
-- >> Values must not be null, zero or negative.
SELECT 
sls_sales AS old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE  
	WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE 
	WHEN sls_price IS NULL OR sls_price <=0
		THEN ABS(sls_sales) / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_price  


-- ================================================
-- Checking 'silver.erp_cust_az12' 
-- ================================================

-- Check for invalid dates
SELECT
cid,
bdate,
gen
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
OR bdate > GETDATE();

-- Data standardization & consistency
SELECT DISTINCT gen,
CASE 
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
	ELSE 'n/a'
END AS gen
FROM silver.erp_cust_az12;




-- ================================================
-- Checking 'silver.erp_loc_a101' 
-- ================================================

-- Data standardization & consistency
SELECT 
DISTINCT cntry,
CASE
	WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
	WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
	WHEN UPPER(TRIM(cntry)) IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'n/a'
	ELSE TRIM(cntry)
END AS cntry
FROM silver.erp_loc_a101


-- ================================================
-- Checking 'silver.erp_px_cat_g1v2' 
-- ================================================

-- Check for unwanted spaces
SELECT *
FROM silver.erp_px_cat_g1v2 
WHERE id != TRIM(id) OR cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data standardization & consistency
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2 

SELECT * 
FROM silver.erp_px_cat_g1v2

