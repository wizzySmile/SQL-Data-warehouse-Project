/*
==============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
==============================================================================
Script Purpose:
  This stored procedure performs the ETL (Extract, Transform, Load) process 
  to populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
  - Truncates Silver tables.
  - Inserts transformed and cleansed data from Bronze into silver tables.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXECUTE silver.load_silver;
==============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	SET @batch_start_time = GETDATE()
	BEGIN TRY
		PRINT('=============================================');
		PRINT'Loading Silver Layer';
		PRINT('=============================================');


		PRINT('====================');
		PRINT'Inserting CRM Tables'
		PRINT('====================');
	SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		PRINT '>>> Inserting cleaned data into: silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info
		(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)
		SELECT 
			cst_id,
			cst_key,
			TRIM(cst_firstname) cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END cst_marital_status,
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				ELSE 'n/a'
			END cst_gndr,
			cst_create_date
		FROM
		(
			SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank_no
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE rank_no = 1;

	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time)AS NVARCHAR) + ' seconds'
	PRINT '------------------------------';

	SET @start_time = GETDATE()
	PRINT 'Truncating Table: silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info
	PRINT '>>> Inserting cleaned data into: silver.crm_prd_info'
	INSERT INTO silver.crm_prd_info
	(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		WHEN 'R' THEN 'Road'
		WHEN 'S' THEN 'Other Sales'
		WHEN 'M' THEN 'Mountain'
		WHEN 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST (prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER  BY prd_start_dt ASC) -1 AS DATE) AS prd_end_dt
	FROM bronze.crm_prd_info;
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) +  ' seconds'
	PRINT '------------------------------';

	SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		PRINT '>>> Inserting cleaned data into: silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details
		(
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
		CASE
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END sls_order_dt,
		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END sls_ship_dt,
		CASE
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END sls_due_dt,
		CASE  
			WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
			sls_quantity,
		CASE 
			WHEN sls_price IS NULL OR sls_price <=0
				THEN ABS(sls_sales) / NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
		FROM bronze.crm_sales_details;
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) + ' seconds'
	PRINT '------------------------------';

		PRINT('====================');
		PRINT'Inserting ERP Tables'
		PRINT('====================');
	SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT '>>> Inserting cleaned data into: silver.erp_cust_az12'
		INSERT INTO silver.erp_cust_az12
		(
			cid,
			bdate,
			gen
		)
		SELECT 
		CASE 
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END AS cid,
		CASE 
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE 
			WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
			WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
			ELSE 'n/a'
		END AS gen
		FROM bronze.erp_cust_az12;
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) + ' seconds'
	PRINT '------------------------------';

	SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT '>>> Inserting cleaned data into: silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101
		(
			cid,
			cntry
		)
		SELECT 
		REPLACE(cid, '-','') as cid,
		CASE
			WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
			WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
			WHEN UPPER(TRIM(cntry)) IS NULL OR UPPER(TRIM(cntry)) = '' THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry
		FROM bronze.erp_loc_a101
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) + ' seconds'
	PRINT '------------------------------';

	SET @start_time = GETDATE()
		PRINT 'Truncating Table: silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT '>>> Inserting cleaned data into: silver.erp_px_cat_g1v2'
		INSERT INTO silver.erp_px_cat_g1v2
		(
		id,
		cat,
		subcat,
		maintenance
		)
		SELECT
		id,
		cat,
		subcat,
		maintenance
		FROM bronze.erp_px_cat_g1v2;
	SET @end_time = GETDATE()
	PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time, @end_time) AS NVARCHAR) + ' seconds'
	PRINT '------------------------------';
	SET @batch_end_time = GETDATE()
	PRINT ' '
	PRINT('=============================================');
	PRINT 'Inserting silver layer is completed'
	PRINT 'Total load duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
	PRINT('=============================================');

	END TRY
	BEGIN CATCH
			PRINT('=============================================');
			PRINT 'ERROR OCCURED DURING INSERTING SILVER LAYER'
			PRINT 'Error message: ' + ERROR_MESSAGE()
			PRINT 'Error number: ' + CAST (ERROR_NUMBER() AS NVARCHAR)
			PRINT 'Error state: ' + CAST (ERROR_STATE() AS NVARCHAR)
			PRINT('=============================================');
	END CATCH
END;

EXECUTE silver.load_silver
