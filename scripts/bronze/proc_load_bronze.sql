/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
  
  This script loads data from CSV files into the bronze layer of a data warehouse.
  It truncates existing tables, loads new data using LOAD DATA INFILE statements,
  and logs the load process
  The script also creates a stored procedure named 'load_bronze' that:
  - Loads data into the CRM and ERP tables.
  - Logs the load process.
  - Returns the results of the load process.

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.
===============================================================================
*/

SET @GLOBAL_START_TIME = NOW();

USE Datawarehouse;
DROP TABLE log_messages;

	CREATE TABLE log_messages ( message TEXT);

	INSERT INTO log_messages (message) VALUES ('==============================');
	INSERT INTO log_messages (message) VALUES ('Loading bronze layer...');
    INSERT INTO log_messages (message) VALUES ('==============================');
    
    INSERT INTO log_messages (message) VALUES ('------------------------------');
	INSERT INTO log_messages (message) VALUES ('Loading CRM tables...');
    INSERT INTO log_messages (message) VALUES ('------------------------------');
    
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_crm_cust_info');
			TRUNCATE TABLE bronze_crm_cust_info;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_crm_cust_info');
	LOAD DATA INFILE "C:/source_crm/cust_info.csv"
	IGNORE INTO TABLE bronze_crm_cust_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                 
			INSERT INTO log_messages (message) 
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_crm_cust_info;
			INSERT INTO log_messages (message) 
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' seconds'));
			INSERT INTO log_messages (message) VALUES ('------------------------------');
                
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_crm_prd_info');
			TRUNCATE TABLE bronze_crm_prd_info;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_crm_prd_info');
	LOAD DATA INFILE "C:/source_crm/prd_info.csv"
	IGNORE INTO TABLE bronze_crm_prd_info
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                
			INSERT INTO log_messages (message)
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_crm_prd_info;
			INSERT INTO log_messages (message)
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND, @START_TIME, @END_TIME), ' seconds'));
			INSERT INTO log_messages (message) VALUES ('------------------------------');
				
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_crm_sales_details');
			TRUNCATE TABLE bronze_crm_sales_details;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_crm_sales_details');
	LOAD DATA INFILE 'C:/source_crm/sales_details.csv'
	IGNORE INTO TABLE bronze_crm_sales_details
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                
			INSERT INTO log_messages (message)
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_crm_sales_details;
			INSERT INTO log_messages (message)
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND, @START_TIME, @END_TIME), ' seconds'));
            
	INSERT INTO log_messages (message) VALUES ('------------------------------');
	INSERT INTO log_messages (message) VALUES ('Loading ERP tables...');
    INSERT INTO log_messages (message) VALUES ('------------------------------');
    
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_erp_cust_az12');
			TRUNCATE TABLE bronze_erp_cust_az12;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_erp_cust_az12');
	LOAD DATA INFILE 'C:/source_erp/CUST_AZ12.csv'
	IGNORE INTO TABLE bronze_erp_cust_az12
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                
			INSERT INTO log_messages (message)
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_erp_cust_az12;
			INSERT INTO log_messages (message)
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND,@START_TIME, @END_TIME), ' seconds'));
			INSERT INTO log_messages (message) VALUES ('------------------------------');
	 
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_erp_loc_a101');
			TRUNCATE TABLE bronze_erp_loc_a101;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_erp_loc_a101');
	LOAD DATA INFILE 'C:/source_erp/LOC_A101.csv'
	IGNORE INTO TABLE bronze_erp_loc_a101
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                
			INSERT INTO log_messages (message)
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_erp_loc_a101;
			INSERT INTO log_messages (message)
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND, @START_TIME, @END_TIME), ' seconds'));
			INSERT INTO log_messages (message) VALUES ('------------------------------');
 
		SET @START_TIME = NOW();
			INSERT INTO log_messages (message) VALUES ('>> Truncating Table: bronze_erp_px_cat_g1v2');
			TRUNCATE TABLE bronze_erp_px_cat_g1v2;
			INSERT INTO log_messages (message) VALUES ('>> Inserting Data Into: bronze_erp_px_cat_g1v2');
 LOAD DATA INFILE 'C:/source_erp/PX_CAT_G1V2.csv'
 IGNORE INTO TABLE bronze_erp_px_cat_g1v2
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n'
 IGNORE 1 ROWS;
		SET @END_TIME = NOW();
                
			INSERT INTO log_messages (message)
			SELECT CONCAT('   Rows affected: ', COUNT(*)) FROM bronze_erp_px_cat_g1v2;
			INSERT INTO log_messages (message)
			VALUES (CONCAT('   Load duration: ', TIMESTAMPDIFF(SECOND, @START_TIME, @END_TIME), ' seconds'));
			INSERT INTO log_messages (message) VALUES ('------------------------------');
            
SET @GLOBAL_END_TIME = NOW();
INSERT INTO log_messages(message)
VALUES (CONCAT('Bronze layer load duration: ', TIMESTAMPDIFF(SECOND, @GLOBAL_START_TIME, @GLOBAL_END_TIME), ' seconds'));
INSERT INTO log_messages (message) VALUES ('>> Bronze Layer Load Process Completed.');


DROP PROCEDURE load_bronze;

DELIMITER //
CREATE PROCEDURE load_bronze()
BEGIN

	SELECT * 
	FROM bronze_crm_cust_info;

	SELECT * 
	FROM bronze_crm_prd_info;

	SELECT * 
	FROM bronze_crm_sales_details;

	SELECT * 
	FROM bronze_erp_cust_az12;

	SELECT * 
	FROM bronze_erp_loc_a101;

	SELECT * 
	FROM bronze_erp_px_cat_g1v2;
    
	SELECT *
    FROM log_messages;
END//
DELIMITER ;
 CALL load_bronze()

